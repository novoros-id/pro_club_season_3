import 'package:go_router/go_router.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/registration/ui/registration_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/diary/ui/diary_screen.dart';
import '../../features/game1/ui/game1_screen.dart';
import '../../features/game2/ui/game2_menu_screen.dart';
import '../../features/game2/ui/game2_play_screen.dart';
import '../../features/analytics/ui/analytics_screen.dart';
import '../../features/authors/ui/authors_screen.dart';
import '../../features/registration/ui/registration_screen.dart';
import '../../features/registration/ui/add_edit_goalkeeper_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/registration', builder: (_, __) => const RegistrationScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/diary', builder: (_, __) => const DiaryScreen()),
    GoRoute(path: '/game1', builder: (_, __) => const Game1Screen()),
    GoRoute(path: '/game2', builder: (_, __) => const Game2MenuScreen()),
    GoRoute(path: '/game2/play', builder: (_, __) => const Game2PlayScreen()),
    GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
    GoRoute(path: '/authors', builder: (_, __) => const AuthorsScreen()),
    GoRoute(path: '/registration', builder: (_, __) => const RegistrationScreen()),
    GoRoute(path: '/add-goalkeeper', builder: (_, __) => const AddEditGoalkeeperScreen()),
  ],
);