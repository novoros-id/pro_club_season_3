# Development commands

- Dependency manifest: `pubspec.yaml`; package manager is Flutter/Dart.
- Dependencies include Drift code generation via `build_runner`; generated sources include `app_database.g.dart` and localization outputs.
- Project files explicitly provide `analysis_options.yaml`, `l10n.yaml`, and a `test` directory with `test/widget_test.dart`.
- Recommended project commands derived from the configured toolchain: `flutter pub get`, `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`.
- No project-specific command documentation was found in `README.md` or `AGENTS.md`; verify command behavior before changing generated outputs.
- Sources: `pubspec.yaml`, `l10n.yaml`, `test/widget_test.dart`, Serena search of `README.md` and `AGENTS.md`.