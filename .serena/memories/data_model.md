# Data model

- Drift database: `lib/core/database/app_database.dart`; `AppDatabase` is annotated with `@DriftDatabase(tables: [Goalkeepers, Matches, Goals])`.
- `Goalkeepers`: auto-increment `id`, unique `uuid`, identity/contact fields, optional `birthDate` and `photoPath`, `isCurrent`.
- `Matches`: auto-increment `id`, foreign key `goalkeeperId -> Goalkeepers.id`, date/opponent/score and match-performance fields, `createdAt`.
- `Goals`: auto-increment `id`, foreign key `matchId -> Matches.id`, goal coordinates/type and `createdAt`.
- Schema version is 4. Database file is `goalkeeper_db.sqlite`, opened through Drift `NativeDatabase.createInBackground`.
- Current schema has no DailyTask or DailyTaskCompletion tables.
- Source: `lib/core/database/app_database.dart`.