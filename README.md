# Laundry App

A Flutter monorepo for managing laundry orders. The primary app, **`laundry_app`**, lets a laundry business register clients, build orders from a catalog of garment/items, and track those orders through their workflow. Backend services are powered by **Supabase**, and shared code (models, repositories, icons) lives in a reusable **`shared_assets`** package.

## Tech Stack

- **Flutter** (Dart SDK `^3.11.3`)
- **Riverpod** (`flutter_riverpod`) — state management
- **Supabase** (`supabase_flutter`) — backend / database
- **flutter_svg** + **hugeicons** — iconography
- **flutter_dotenv** — environment configuration

## Repository Structure

```
.
├── apps/
│   ├── laundry_app/          # Main laundry-management app (actively developed)
│   └── client_app/           # Client-facing app (scaffold/placeholder)
├── shared_assets/            # Shared Flutter package (models, services, icons)
├── supabase/                 # Supabase migrations & project config
├── scripts/                  # Repo-level scripts
└── CLAUDE.md                 # Guidance for Claude Code
```

> **Note:** This is a *manual* monorepo — there is no root `pubspec.yaml` or melos workspace. Each package manages its own dependencies, and the apps depend on `shared_assets` via a local `path:` reference.

### `apps/laundry_app/` — main app

```
lib/
├── main.dart                 # Entry point: loads .env, initializes Supabase, runs App
├── app.dart                  # Root MaterialApp (theme + routes)
├── app_theme.dart            # AppTheme.lightTheme
├── providers/                # Riverpod state (Notifier-based)
│   ├── clients_provider.dart
│   ├── items_provider.dart
│   ├── orders_provider.dart
│   └── order_items_provider.dart
├── utils/
│   ├── routes.dart           # Static route table (Routes.all)
│   └── navigation_controller.dart
└── presentations/
    ├── widgets/              # App-wide reusable widgets (Laundry* components)
    └── screens/              # Feature screens, each in its own directory
        ├── home/             #   order list + add-order entry point
        ├── add_order/        #   build a new order & associate a client
        ├── items_picker/     #   pick garments/items for an order
        ├── register_client/  #   register a new client
        ├── items_manager/    #   manage the item catalog
        ├── settings/         #   settings menu
        └── loading/          #   generic async loading page
```

Screen-specific widgets live in a `widgets/` subdirectory inside each screen folder.

### `shared_assets/` — shared package

```
lib/
├── models/                   # Data models with fromJson()/toJson()
│   ├── client_model.dart     #   ClientModel + ClientStatus (active | deleted)
│   ├── item_model.dart       #   ItemModel (catalog garment, has iconName)
│   ├── order_model.dart      #   OrderModel + OrderStatus (doing | completed | deleted)
│   └── order_item_model.dart #   OrderItemModel (join: order ↔ item, qty)
├── services/
│   ├── supabase_service.dart # Singleton that wires up all repositories
│   └── repositories/         # One repository per table
│       ├── clients_repository.dart
│       ├── items_repository.dart
│       ├── orders_repository.dart
│       └── order_items_repository.dart
├── icons/                    # SVG-backed icon widgets (WasherIcon, WashOrderIcon)
├── assets/                   # Raw SVGs (washer-icon.svg, wash-order-icon.svg)
└── utils/
    └── huge_icons_map.dart   # Name → hugeicons IconData lookup
scripts/
└── generate_icon_map.dart    # Regenerates huge_icons_map.dart from the hugeicons package
```

### `apps/client_app/` — client app

A Flutter scaffold for the client-facing application. Currently minimal and not the focus of active development.

## Architecture

### State management (Riverpod)

State is exposed via `NotifierProvider`s in `apps/laundry_app/lib/providers/`. Each provider pairs a `*State` class with a `Notifier` (e.g. `ordersProvider`, `clientsProvider`, `itemsProvider`, `orderItemsProvider`). Screens use `ConsumerWidget` / `ConsumerStatefulWidget` and read state through `ref`.

### Data layer (Supabase + repositories)

`SupabaseService` is a singleton (`SupabaseService.instance`) initialized once in `main.dart`. It constructs and holds one repository per table:

| Repository | Table | Notes |
|------------|-------|-------|
| `ClientsRepository` | `clients` | Filters out `status = deleted` |
| `ItemsRepository` | `items` | Filters out `deleted = true` |
| `OrdersRepository` | `orders` | Joins `clients` + `order_items(items)`, hides `deleted` |
| `OrderItemsRepository` | `order_items` | Join table between orders and items |

Repositories wrap Supabase queries and convert rows to/from models using `fromJson()` / `toJson()`. Soft-deletes are used throughout (status enums / `deleted` flags) rather than hard deletes.

### Navigation

Routes are declared statically in `lib/utils/routes.dart` as a `Map<String, WidgetBuilder>` (`Routes.all`), with the app entering at `Routes.home`. Nested routes are namespaced by prefix (e.g. `addOrder = '/items_picker/add_order'`). The home route renders a `NavigationController`, which also surfaces toast messages passed as route arguments.

## Data Model

The Supabase schema (see `supabase/migrations/`) centers on five tables:

- **`laundries`** — the business/tenant (each item and order belongs to a laundry).
- **`clients`** — customers (`name`, `phone_number`, `status`).
- **`items`** — the catalog of garments/services (`name`, `icon_name`, `deleted`).
- **`orders`** — a customer order (`order_number`, `client_id`, `delivery_date`, `status`).
- **`order_items`** — line items linking an order to catalog items with `quantity` and `description`.

All tables carry `created_at` / `updated_at`, and `updated_at` is maintained automatically by the shared `update_updated_at()` trigger.

## Environment Setup

The main app loads configuration from `apps/laundry_app/.env` (registered as a Flutter asset and loaded in `main.dart`). Required variables:

| Variable | Description |
|----------|-------------|
| `PROJECT_URL` | Supabase project URL |
| `ANON_KEY` | Supabase anonymous (public) API key |

Create `apps/laundry_app/.env`:

```env
PROJECT_URL=https://your-project.supabase.co
ANON_KEY=your-anon-key
```

## Getting Started

```bash
# Install dependencies (per package)
cd shared_assets && flutter pub get
cd ../apps/laundry_app && flutter pub get

# Run the main app
flutter run
```

## Development Commands

Run from `apps/laundry_app/` (or the relevant package):

```bash
flutter run                 # Run the app
flutter build ios           # iOS build
flutter build apk           # Android APK
flutter analyze             # Static analysis / lint
dart format lib/            # Format code
flutter test                # Run tests
flutter pub get             # Install dependencies
flutter pub outdated        # Check for dependency updates
```

### Regenerating the icon map

The `huge_icons_map.dart` lookup is generated from the installed `hugeicons` package:

```bash
cd shared_assets
dart scripts/generate_icon_map.dart
```

## Linting

Linting uses `flutter_lints` (with Flutter-recommended rules). Configuration lives in each package's `analysis_options.yaml`.

## Database Migrations

SQL migrations live in `supabase/migrations/` and are applied via the Supabase CLI. Migrations are timestamp-prefixed and applied in order. Recent migrations added soft-delete status enums to clients/orders, a `deleted` flag and `icon_name` to items, and an order `delivery_date`.
