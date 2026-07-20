# Navigation and UI

- Router function: `appRouter({required bool hasKeepers})` in `lib/core/router/app_router.dart`.
- Initial location is `/` when `hasKeepers == true`, otherwise `/onboarding`.
- Registered routes: `/`, `/onboarding`, `/registration`, `/add-goalkeeper`, `/settings`, `/diary`, `/analytics`, `/game1`, `/game2`, `/game2/play`, `/game_schulte`, `/game_schulte/play`, `/game_schulte/settings`, `/authors`.
- UI screens are under feature `ui` directories.
- Source: `lib/core/router/app_router.dart`; app wiring: `lib/main.dart`.