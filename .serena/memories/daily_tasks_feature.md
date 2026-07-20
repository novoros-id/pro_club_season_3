# Daily tasks feature

Status: MVP specification only; no `DailyTask` or `DailyTaskCompletion` implementation exists in the current codebase.

- Tasks belong to the current goalkeeper through `goalkeeperId`.
- Do not create a separate user entity.
- MVP includes daily tasks only.
- One-time tasks are deferred.
- Weekday-based repetition is deferred.
- Completion is tied to the actual local calendar date.
- Manual shifting of the completion date is not supported.
- Completion after the specified time is allowed.
- Completion after the specified time is recorded as late.
- Notifications are implemented after the main MVP.
- Storage is local through Drift.
- Backend and synchronization are absent from the MVP.
- `DailyTask` and `DailyTaskCompletion` are separate entities.
- Do not create physical task copies for each day.
- Preliminary completion uniqueness: `taskId + occurrenceDate`.
- Existing-code fact checked with Serena search across `lib`: no matching symbols/tables were found.