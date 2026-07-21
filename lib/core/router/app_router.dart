import 'package:go_router/go_router.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/registration/ui/registration_screen.dart';
import '../../features/registration/ui/onboarding_screen.dart';
import '../../features/registration/ui/add_edit_goalkeeper_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/diary/ui/diary_main_screen.dart';
import '../../features/game1/ui/game1_screen.dart';
import '../../features/game2/ui/game2_menu_screen.dart';
import '../../features/game2/ui/game2_play_screen.dart';
import '../../features/game_schulte/ui/schulte_home_screen.dart';
import '../../features/game_schulte/ui/schulte_screen.dart';
import '../../features/game_schulte/ui/schulte_settings_screen.dart';
import '../../features/analytics/ui/analytics_screen.dart';
import '../../features/authors/ui/authors_screen.dart';
import '../../features/daily_tasks/ui/daily_tasks_screen.dart';
import '../../features/daily_tasks/ui/daily_task_edit_screen.dart';
import '../../core/database/app_database.dart';

// ✅ Роутер теперь принимает параметр
GoRouter appRouter({required bool hasKeepers}) {
  return GoRouter(
    // Если вратарей нет, начинаем с онбординга. Иначе с главного экрана.
    initialLocation: hasKeepers ? '/' : '/onboarding',

    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/registration',
        builder: (_, __) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/add-goalkeeper',
        builder: (_, __) => const AddEditGoalkeeperScreen(),
      ),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/diary', builder: (_, __) => const DiaryMainScreen()),
      GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
      GoRoute(path: '/game1', builder: (_, __) => const Game1Screen()),
      GoRoute(path: '/game2', builder: (_, __) => const Game2MenuScreen()),
      GoRoute(path: '/game2/play', builder: (_, __) => const Game2PlayScreen()),
      GoRoute(
        path: '/game_schulte',
        builder: (_, __) => const SchulteHomeScreen(),
      ),
      GoRoute(
        path: '/game_schulte/play',
        builder: (_, __) => const SchulteScreen(),
      ),
      GoRoute(
        path: '/game_schulte/settings',
        builder: (_, __) => const SchulteSettingsScreen(),
      ),
      GoRoute(path: '/authors', builder: (_, __) => const AuthorsScreen()),
      GoRoute(
        path: '/daily-tasks',
        builder: (_, __) => const DailyTasksScreen(),
      ),
      GoRoute(
        path: '/daily-tasks/new',
        builder: (_, __) => const DailyTaskEditScreen(),
      ),
      GoRoute(
        path: '/daily-tasks/edit/:id',
        builder: (_, state) =>
            DailyTaskEditScreen(task: state.extra as DailyTask),
      ),
    ],
  );
}
