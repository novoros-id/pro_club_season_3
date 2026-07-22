# UI and localization

- ARB sources: `lib/l10n/app_en.arb` and `lib/l10n/app_ru.arb`; generated Dart localization files are outputs.
- Daily-task user-facing strings use ARB keys with RU and EN values; no new hardcoded UI strings were found in the feature.
- Daily metrics use distinct keys for completed count, remaining/active tasks, and completion percentage; compact labels are separate keys.
- Daily-task UI strings include create/edit/delete, validation, empty/no-goalkeeper/error states, statistics, recent completed days, and no-statistics state.
- Keep generated localization files synchronized by `flutter gen-l10n`; do not hand-edit them.