# Development workflow

- Preserve the feature-oriented structure under `lib/features` and shared services under `lib/core`.
- Read and update Drift schema in `lib/core/database/app_database.dart`; `app_database.g.dart` is generated and should not be hand-edited.
- Use Riverpod providers for database, storage, settings, and feature controllers.
- Route changes belong in `lib/core/router/app_router.dart`; app startup decisions are made in `lib/main.dart`.
- Localization changes start in `lib/l10n/*.arb` and follow `l10n.yaml`; generated localization Dart files are outputs.
- Validate changes with the configured Flutter analyzer and tests; run code generation only when source schema/localization changes require it.
- Current code search found no daily-task implementation; do not infer one from existing diary or match features.