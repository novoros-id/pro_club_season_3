# Architecture

- Feature-oriented layout: UI and logic are grouped below `lib/features/<feature>/ui`, `logic`, and `models`/widgets where present.
- Shared infrastructure is under `lib/core`: router, database, providers, services.
- `main()` initializes `StorageService`, creates a temporary Riverpod `ProviderContainer` to read `databaseProvider`, checks existing goalkeepers, then runs the app inside `ProviderScope`.
- Controllers use Riverpod providers; examples include `GoalkeepersController`, `RegistrationController`, `Game2Controller`, and `SettingsController`.
- Database access is provided by `databaseProvider` returning `AppDatabase`.
- Sources: `lib/main.dart`, `lib/core/database/database_provider.dart`, `lib/core/services/storage_service.dart`, `lib/features/**/logic/*.dart`.