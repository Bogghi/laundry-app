# shared_assets

Shared Flutter package for the laundry app monorepo. Contains models, backend services, icons, and utilities used by both `laundry_app` and `client_app`.

## Contents

- **models/** — Data models (`ClientModel`, `OrderModel`, `ItemModel`, `OrderItemModel`)
- **services/** — Supabase client initialisation and repository classes for all entities
- **icons/** — SVG icon widgets (`WasherIcon`, `WashOrderIcon`)
- **utils/** — Shared utilities, including the auto-generated `hugeIconsMap`

## Icon map

`lib/utils/huge_icons_map.dart` is auto-generated from the `hugeicons` package. To regenerate it (e.g. after a `hugeicons` version bump):

```bash
cd shared_assets
flutter pub get
dart scripts/generate_icon_map.dart
```

## Usage

Add the package as a path dependency in your app's `pubspec.yaml`:

```yaml
dependencies:
  shared_assets:
    path: '../../shared_assets'
```
