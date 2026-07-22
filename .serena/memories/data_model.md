# Data model

- Drift schema version: 5.
- Existing `Goalkeepers`, `Matches`, and `Goals` remain in the schema.
- `DailyTasks`: auto-increment task id, `goalkeeperId`, title/description, recurrence type, `isEnabled`, `createdAt`, `updatedAt`, nullable `deletedAt`.
- `DailyTaskCompletions`: `taskId`, normalized `occurrenceDate`, `completedAt`; no separate completion id.
- Composite primary key: `(taskId, occurrenceDate)`.
- Migration 4 -> 5 creates the two daily-task tables and preserves existing tables/data.
- Soft delete preserves completion history.
- Historical daily total uses task `createdAt` and `deletedAt`; enable/disable history is not stored, so past `isEnabled` state cannot be reconstructed.
- Statistics query tasks are filtered by `goalkeeperId`; completion counts are matched only to task ids belonging to that goalkeeper.
- Daily statistics query only `today - 2 days ... today`; older completions are excluded.