# Data model

- Drift schema version: 6.
- Existing `Goalkeepers`, `Matches`, and `Goals` remain in the schema.
- `DailyTasks`: auto-increment local id, unique non-null UUID v4, `goalkeeperId`, title/description, recurrence type, `isEnabled`, `createdAt`, `updatedAt`, nullable `deletedAt`.
- New tasks receive a client-generated UUID v4 by default; explicit UUIDs are accepted for import/sync, while the database enforces uniqueness.
- `DailyTaskCompletions`: `taskId`, normalized `occurrenceDate`, `completedAt`; no separate completion id.
- Composite primary key: `(taskId, occurrenceDate)`.
- Migration 4 -> 5 creates the daily-task tables. Opening v4 directly on schema v6 creates the current tables.
- Migration 5 -> 6 rebuilds `daily_tasks`, assigns stable UUID v4 values to existing rows, preserves ids/data/completion foreign keys, and restores foreign-key enforcement.
- Soft delete preserves completion history.
- Historical daily total uses task `createdAt` and `deletedAt`; enable/disable history is not stored, so past `isEnabled` state cannot be reconstructed.
- Statistics query tasks are filtered by `goalkeeperId`; completion counts are matched only to task ids belonging to that goalkeeper.
- Daily statistics query only `today - 2 days ... today`; older completions are excluded.