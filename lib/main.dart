import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <--- ВАЖНО: Добавь этот импорт
import 'core/router/app_router.dart';
import 'core/database/database_provider.dart';
import 'l10n/app_localizations.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService().init();

  final container = ProviderContainer();
  final db = container.read(databaseProvider);

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

      // ✅ ЖЕСТКО ЗАДАЕМ РУССКИЙ ЯЗЫК
      locale: const Locale('ru'),

      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Lato',
      ),

      // ✅ УКАЗЫВАЕМ ДЕЛЕГАТЫ И ПОДДЕРЖИВАЕМЫЕ ЛОКАЛИ
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
        Locale('en'), // Можно оставить английский в списке, но locale выше переопределит его
      ],

      routerConfig: _router,
    );
  }
}