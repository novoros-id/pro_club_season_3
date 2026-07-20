# UI and localization

- Localization source ARB files: `lib/l10n/app_en.arb` and `lib/l10n/app_ru.arb`.
- Localization configuration: `l10n.yaml`; ARB directory `lib/l10n`, template `app_en.arb`, output `app_localizations.dart`.
- Generated localization files exist under `lib/l10n` and `lib/l10n/generated`; they are generated artifacts and must not be edited for feature work.
- `MaterialApp.router` uses `AppLocalizations.localizationsDelegates` and `AppLocalizations.supportedLocales`.
- Default locale provider value is `Locale('ru')`; default theme is light; sound defaults to enabled with volume `0.8`.
- Main font configured in `GoalkeeperApp` is `Lato`.
- Sources: `l10n.yaml`, `lib/main.dart`, `lib/core/providers/settings_provider.dart`.