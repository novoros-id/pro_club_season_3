# Daily tasks feature

- MVP: local Drift daily tasks scoped by current goalkeeper; no backend/sync.
- Structure: `lib/features/daily_tasks/{data,logic,models,ui}`.
- Data operations: create, edit title/description, enable/disable, soft delete, complete/uncomplete.
- Task identity: local auto-increment id plus stable unique UUID v4; ordinary updates, enable/disable, and soft delete do not change the UUID.
- Completion uses normalized local calendar date `DateTime(year, month, day)`; uniqueness is `taskId + occurrenceDate`; repeated completion preserves `completedAt`.
- Today stats expose `completedToday`, `totalTasksToday`, `remainingActiveTasksToday`, and zero-safe `completionPercentToday`.
- Day statistics use strictly today, yesterday, and two days ago; completions older than two days ago are excluded; days without completion are hidden; maximum is three cards.
- All statistics are isolated by `goalkeeperId`.
- Past-day totals use task `createdAt`/`deletedAt`; no historical `isEnabled` data exists.
- UI uses Unbounded headings, Lato body text, dark/lime/light-gray palette, compact metric row, square day cards, horizontal scrolling, and scrollable task/edit layouts.
- Routes: `/daily-tasks`, `/daily-tasks/new`, `/daily-tasks/edit/:id`; entry from the home menu.
- Tests: `test/features/daily_tasks/daily_tasks_test.dart`, including UUID generation/uniqueness/stability and v4/v5 migration coverage.
- MVP limits: no one-time/weekday recurrence, notifications, late/isLate model, or manual completion-date shifting.