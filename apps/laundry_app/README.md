# Pristine — Laundry App

A Flutter application (branded **Pristine** in-app) for managing the day-to-day
workflow of a laundry business: registering clients, building orders from a
catalog of garments, tracking delivery dates, and sorting/filtering the order
book. The UI is in **Italian**.

This is the primary, actively developed app in the [`laundry-app`](../../) monorepo.
It depends on the shared `shared_assets` package for data models and backend
access, and on a Supabase project for persistence.

## Features

- **Order management** — create, edit, and soft-delete orders. Each order has an
  order number, an associated client, an optional delivery date, and a status
  (`doing`, `completed`, `deleted`). Swipe an order card to delete it (with a
  confirmation dialog); deletes are *soft* — the row's status is flipped to
  `deleted` and filtered out of the list, not removed from the database.
- **Order line items** — pick garments and quantities from the item catalog when
  building an order. Edits reconcile against what's persisted (insert new lines,
  update changed quantities, delete removed lines).
- **Filtering & sorting** — a slide-in filter panel on the home screen filters
  the order list live by client name and order number, and sorts by created date,
  delivery date, order number (numeric-aware, so `#2` precedes `#10`), or client
  name. An indicator dot on the AppBar shows when filters/sort are active.
- **Client management** — register and edit clients (name, phone number), and
  associate them with orders.
- **Item (garment) management** — maintain the catalog of items, each with a name
  and an icon, including a dedicated icon picker for choosing a glyph per item.

## Tech stack

| Concern          | Choice                                          |
|------------------|-------------------------------------------------|
| UI               | Flutter (Dart SDK `^3.11.3`)                     |
| State management | [Riverpod](https://riverpod.dev) (`flutter_riverpod`) |
| Backend          | [Supabase](https://supabase.com) (`supabase_flutter`) |
| Icons            | `hugeicons`, `flutter_svg`, `cupertino_icons`   |
| Config           | `flutter_dotenv` (`.env`)                        |
| Shared code      | `shared_assets` (local path package)            |

## Project structure

```
lib/
├── main.dart                  # Entry point: loads .env, inits Supabase, runs App
├── app.dart                   # Root MaterialApp (theme, routes, initial route)
├── app_theme.dart             # Color palette and light theme
├── providers/                 # Riverpod state (orders, clients, items, order_items)
├── presentations/
│   ├── screens/               # Feature screens, each in its own directory
│   │   ├── home/              # Order list, filter panel, sort, order cards
│   │   ├── order_info/        # Create / edit an order
│   │   ├── items_picker/      # Pick garments + quantities for an order
│   │   ├── items_manager/     # Manage the garment catalog
│   │   ├── new_items_icon_picker/  # Choose an icon for a garment
│   │   ├── clients_manager/   # Client list
│   │   ├── client_info/       # Create / edit a client
│   │   └── loading/           # Generic async loading page
│   └── widgets/               # Reusable widgets (cards, lists, fields, toast…)
└── utils/
    ├── routes.dart            # Static route table (Map<String, WidgetBuilder>)
    ├── navigation_controller.dart
    └── order_sorter.dart      # Pure sort function for the order list
```

Data models (`OrderModel`, `ClientModel`, `ItemModel`, `OrderItemModel`),
repository classes, and the `SupabaseService` singleton live in
[`../../shared_assets/`](../../shared_assets/). Database schema lives in
[`../../supabase/migrations/`](../../supabase/migrations/).

## Getting started

### 1. Prerequisites

- Flutter SDK with Dart `^3.11.3`
- A Supabase project (URL + anon key)

### 2. Configure the environment

Create a `.env` file in this directory (`apps/laundry_app/.env`) — it is loaded by
`flutter_dotenv` in `main.dart` and listed as a bundled asset in `pubspec.yaml`:

```env
PROJECT_URL=https://your-project.supabase.co
ANON_KEY=your-supabase-anon-key
```

> The app reads these in `main.dart` to initialize Supabase before the first
> frame. Both are required; startup throws if either is missing.

### 3. Install dependencies and run

```bash
flutter pub get
flutter run
```

## Common commands

```bash
flutter run            # Run on the connected device/emulator
flutter build ios      # iOS build
flutter build apk      # Android APK
flutter analyze        # Static analysis (flutter_lints + riverpod_lint)
dart format lib/       # Format
flutter test           # Run tests in test/
flutter pub get        # Resolve dependencies
flutter pub outdated   # Check for dependency updates
```

## Architecture notes

- **State** is managed with Riverpod. `OrdersProvider` (a `Notifier`) owns the
  in-flight order list plus the draft being created/edited (selected items,
  client, delivery date, order number). Screens read it via `ConsumerWidget` /
  `ConsumerStatefulWidget` and `ref`.
- **Navigation** uses a static route table in `utils/routes.dart`. Routes that
  take arguments use typed records (e.g. `OrderInfoArgs = ({OrderModel? order})`)
  passed via `Navigator.pushNamed(..., arguments: ...)`. Add new screens here.
- **Backend access** goes through repository classes in `shared_assets`
  (`SupabaseService.instance.orders`, `.clients`, `.items`, `.orderItems`), which
  wrap Supabase queries and map rows to models via `fromJson` factories.
- **Soft deletes**: orders and clients are removed by setting a `deleted` status;
  `getAll()` filters those out rather than issuing a hard `DELETE`.

## Adding a new screen

1. Create `lib/presentations/screens/{feature}/{feature}_page.dart` as a
   `ConsumerWidget` (or `ConsumerStatefulWidget`).
2. Put screen-specific widgets in a `widgets/` subdirectory next to it.
3. Register a route constant and builder in `lib/utils/routes.dart`.
