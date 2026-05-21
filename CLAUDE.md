# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Laundry App is a Flutter application for managing laundry orders. The project uses a monorepo structure with two main Flutter apps (`client_app`, `laundry_app`) and shared code in `shared_assets`. The primary app being developed is `laundry_app`, which manages order workflow including client registration, garment selection, and order management.

**Tech stack:**
- Flutter (Dart 3.11.3+)
- Riverpod for state management
- Supabase for backend services
- Flutter SVG for icons

## Repository Structure

```
apps/
  ├── client_app/          # Client-side Flutter app
  └── laundry_app/         # Main laundry management app
shared_assets/
  ├── lib/
  │   ├── models/          # Shared data models (ClientModel, OrderModel, etc.)
  │   ├── services/        # Backend services (SupabaseService, repositories)
  │   ├── icons/           # SVG icon components (WasherIcon, WashOrderIcon)
  │   └── assets/          # Static assets
supabase/                   # Supabase migrations and configuration
```

## Key Architecture

### State Management (Riverpod)
State is managed using Riverpod providers in `lib/providers/`:
- `app_provider.dart` - Global app state
- `clients_provider.dart` - Client list state
- `orders_provider.dart` - Order management state

Screens should use `ConsumerWidget` or `ConsumerStatefulWidget` to access providers via `ref`.

### Presentation Layer
Screens are organized by feature in `lib/presentations/screens/`:
- Each screen has its own directory with a main `*_page.dart`
- Reusable widgets for each screen go in a `widgets/` subdirectory
- Main screens: `home/`, `add_order/`, `register_client/`, `items_picker/`

### Shared Services
`shared_assets` contains backend integration:
- `SupabaseService` initializes the Supabase client (called in `main.dart`)
- Repository classes handle database queries (in `services/repositories/`)

### Navigation
Routes are defined statically in `lib/utils/routes.dart` as a `Map<String, WidgetBuilder>`. Add new routes here when creating new pages.

## Development Commands

### Running the app
```bash
cd apps/laundry_app
flutter run
```

### Building for iOS/Android
```bash
cd apps/laundry_app
flutter build ios    # iOS build
flutter build apk    # Android APK
```

### Code analysis and linting
```bash
cd apps/laundry_app
flutter analyze      # Run dart analyzer
dart format lib/     # Format code
```

### Testing
```bash
cd apps/laundry_app
flutter test         # Run tests in test/ directory
```

### Dependency management
```bash
cd apps/laundry_app
flutter pub get      # Get dependencies
flutter pub outdated # Check for updates
```

## Environment Setup

Configuration is loaded from `.env` file in `apps/laundry_app/`. Required variables:
- `PROJECT_URL` - Supabase project URL
- `ANON_KEY` - Supabase anonymous API key

The `.env` file is loaded in `main.dart` using `flutter_dotenv` before initializing Supabase.

## Linting and Code Quality

The project uses `flutter_lints` with Riverpod lint support (`riverpod_lint: 3.1.3`). Check `analysis_options.yaml` for configured rules. The analyzer is configured to use Flutter recommended lint rules.

## Key Patterns

### Adding a new screen
1. Create a directory in `lib/presentations/screens/{feature_name}/`
2. Create `{feature_name}_page.dart` as a `ConsumerWidget`
3. Add the route to `Routes.all` in `lib/utils/routes.dart`
4. Create a `widgets/` subdirectory for screen-specific widgets

### Working with Riverpod providers
- Use `StateNotifierProvider` for mutable state
- Use `FutureProvider` for async data fetching
- Access in widgets via `ConsumerWidget` and `ref` parameter

### Database operations
Use repository classes in `shared_assets/lib/services/repositories/` to abstract database operations. They wrap Supabase queries and handle model conversion.

## Important Notes

- The app is under active development; recent commits show focus on garment selection UI and order workflow
- Supabase is configured for public anonymous access via `ANON_KEY` in `.env`
- Models in `shared_assets` have `fromJson()` factory constructors for Supabase data deserialization
- The project uses Dart formatting options configured in `.dart_format_options`
