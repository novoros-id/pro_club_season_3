# Navigation and UI

- Router: `appRouter({required bool hasKeepers})`; stable instance is held by `GoalkeeperApp`.
- Daily-task routes: `/daily-tasks`, `/daily-tasks/new`, `/daily-tasks/edit/:id`.
- Home menu opens `/daily-tasks`.
- Daily-task screens use Unbounded headings and Lato body text with `#121212`, `#BBF246`, `#F2F2F7`, and `#9B9EA1` palette.
- Stats metrics share a three-column alignment; labels are capped at two lines.
- Day cards are equal square sizes; narrow layouts use horizontal scrolling.
- Task and edit pages are scrollable; FAB is present only when a current goalkeeper exists.
- Existing non-daily routes remain unchanged.