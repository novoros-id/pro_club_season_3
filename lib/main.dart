import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/database/database_provider.dart';
import 'l10n/app_localizations.dart';
import 'core/services/storage_service.dart'; // Импорт сервиса
//import 'app.dart';

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

  // Очищаем контейнер, так как он больше не нужен (или передаем его в runApp, если нужно)
  // Но проще просто запустить приложение с новым роутером

  runApp(
    ProviderScope(
      child: GoalkeeperApp(hasKeepers: hasKeepers),
    ),
  );
}

class GoalkeeperApp extends StatelessWidget {
  final bool hasKeepers;
  const GoalkeeperApp({super.key, required this.hasKeepers});

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
      routerConfig: appRouter(hasKeepers: hasKeepers), // Передаем флаг в роутер
    );
  }
}