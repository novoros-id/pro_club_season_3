import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';
import 'core/database/database_provider.dart';
import 'l10n/app_localizations.dart';
import 'core/services/storage_service.dart'; // Импорт сервиса

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService().init();

  // Инициализируем провайдеры
  final container = ProviderContainer();

  // Получаем экземпляр базы данных
  final db = container.read(databaseProvider);

  // Проверяем наличие вратарей
  final keepers = await db.getAllGoalkeepers();
  final hasKeepers = keepers.isNotEmpty;

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: GoalkeeperApp(hasKeepers: hasKeepers),
    ),
  );
}

class GoalkeeperApp extends StatefulWidget {
  final bool hasKeepers;
  const GoalkeeperApp({super.key, required this.hasKeepers});

  @override
  State<GoalkeeperApp> createState() => _GoalkeeperAppState();
}

class _GoalkeeperAppState extends State<GoalkeeperApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = appRouter(hasKeepers: widget.hasKeepers);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Goalkeeper Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Lato', // Основной шрифт
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
