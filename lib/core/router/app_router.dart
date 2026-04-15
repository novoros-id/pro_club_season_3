// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/registration/ui/registration_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/diary/ui/diary_screen.dart';      // → DiaryScreen
import '../../features/game1/ui/game1_screen.dart';       // → Game1Screen
import '../../features/game2/ui/game2_screen.dart';       // → Game2Screen

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/registration', builder: (_, __) => const RegistrationScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/diary', builder: (_, __) => const DiaryScreen()),      // ✓
    GoRoute(path: '/game1', builder: (_, __) => const Game1Screen()),      // ✓
    GoRoute(path: '/game2', builder: (_, __) => const Game2Screen()),      // ✓
  ],
);