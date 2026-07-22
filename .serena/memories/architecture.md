# Architecture

- Feature-first Flutter layout; daily tasks are under `lib/features/daily_tasks/{data,logic,models,ui}`.
- Drift database is exposed through Riverpod `databaseProvider`.
- `main()` creates one `ProviderContainer`, reads the database, and passes that same container to `UncontrolledProviderScope`.
- `databaseProvider` creates `AppDatabase` once per container and closes it through `ref.onDispose`.
- `GoalkeeperApp` creates `GoRouter` once in `State.initState`, not during rebuild.
- Daily-task UI uses controllers, not direct Drift queries; data access is isolated in `DailyTasksData`.
- Daily-task logic does not depend on BuildContext or localized strings; UI owns navigation and messages.
- Daily-task statistics enforce both strict three-day range and goalkeeper data isolation.