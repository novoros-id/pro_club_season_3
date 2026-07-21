import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:goalkeeper_trainer/core/database/app_database.dart';
import 'package:goalkeeper_trainer/core/database/database_provider.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/data/daily_tasks_data.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/logic/daily_task_date.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/logic/daily_tasks_logic.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/ui/daily_task_edit_screen.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/ui/daily_tasks_screen.dart';
import 'package:goalkeeper_trainer/l10n/app_localizations.dart';

void main() {
  late AppDatabase db;
  late DailyTasksData data;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    data = DailyTasksData(db);
  });

  tearDown(() => db.close());

  Future<int> addKeeper({bool current = true}) => db
      .into(db.goalkeepers)
      .insert(
        GoalkeepersCompanion.insert(
          uuid: const Uuid().v4(),
          firstName: 'Иван',
          lastName: 'Иванов',
          hand: 'right',
          isCurrent: Value(current),
        ),
      );

  Future<void> pumpTaskForm(WidgetTester tester, {DailyTask? task}) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('Task list')),
        ),
        GoRoute(
          path: '/task',
          builder: (_, _) => DailyTaskEditScreen(task: task),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.text('Task list')),
    );
    await container.read(dailyTasksControllerProvider.notifier).refresh();
    router.push('/task');
    await tester.pumpAndSettle();
  }

  test('normalizes a date to local midnight', () {
    final result = normalizeOccurrenceDate(DateTime(2026, 7, 20, 18, 42, 11));
    expect(result, DateTime(2026, 7, 20));
  });

  test('returns no current goalkeeper when none is selected', () async {
    await addKeeper(current: false);
    expect(await data.currentGoalkeeper(), isNull);
  });

  test('tasks are isolated by goalkeeper and active state', () async {
    final first = await addKeeper();
    final second = await addKeeper(current: false);
    await data.createTask(
      DailyTasksCompanion.insert(goalkeeperId: first, title: 'Первый'),
    );
    await data.createTask(
      DailyTasksCompanion.insert(goalkeeperId: second, title: 'Второй'),
    );

    expect(
      (await data.tasksForDate(first, DateTime.now())).map((e) => e.task.title),
      ['Первый'],
    );
  });

  test('completion is unique, removable, and date-specific', () async {
    final keeper = await addKeeper();
    final taskId = await data.createTask(
      DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Разминка'),
    );
    final date = DateTime(2026, 7, 20, 12);

    await data.complete(taskId, date);
    final firstCompletion =
        (await db.select(db.dailyTaskCompletions).get()).single;
    await data.complete(taskId, date);
    final completions = await db.select(db.dailyTaskCompletions).get();
    expect(completions, hasLength(1));
    expect(completions.single.completedAt, firstCompletion.completedAt);
    expect((await data.tasksForDate(keeper, date)).single.isCompleted, isTrue);
    expect(
      (await data.tasksForDate(
        keeper,
        date.add(const Duration(days: 1)),
      )).single.isCompleted,
      isFalse,
    );

    await data.uncomplete(taskId, date);
    expect(await db.select(db.dailyTaskCompletions).get(), isEmpty);
  });

  test(
    'soft delete keeps completion and enabled tasks can be toggled',
    () async {
      final keeper = await addKeeper();
      final taskId = await data.createTask(
        DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Сохранить'),
      );
      final date = DateTime(2026, 7, 20);
      await data.complete(taskId, date);
      await data.softDelete(taskId);
      expect(await db.select(db.dailyTaskCompletions).get(), hasLength(1));
      expect(await data.tasksForDate(keeper, date), isEmpty);

      final enabledId = await data.createTask(
        DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Включать'),
      );
      await data.setEnabled(enabledId, false);
      expect(await data.tasksForDate(keeper, date), isEmpty);
      await data.setEnabled(enabledId, true);
      expect(await data.tasksForDate(keeper, date), hasLength(1));
    },
  );

  test('statistics count current active tasks and completions', () async {
    final keeper = await addKeeper();
    final first = await data.createTask(
      DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Раз'),
    );
    await data.createTask(
      DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Два'),
    );
    final date = normalizeOccurrenceDate(DateTime.now());
    await data.complete(first, date);

    final stats = await data.stats(keeper, date);
    expect(stats.totalTasksToday, 2);
    expect(stats.completedToday, 1);
    expect(stats.remainingActiveTasksToday, 1);
    expect(stats.completionPercentToday, 50);
    expect(stats.recentDays, hasLength(1));
    expect(stats.recentDays.single.totalCount, 2);
    expect(stats.recentDays.single.completedCount, 1);
  });

  test('active task statistics update when completion is toggled', () async {
    final keeper = await addKeeper();
    final taskIds = <int>[];
    for (var i = 0; i < 7; i++) {
      taskIds.add(
        await data.createTask(
          DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Задача $i'),
        ),
      );
    }
    final date = normalizeOccurrenceDate(DateTime.now());
    await data.complete(taskIds[0], date);
    await data.complete(taskIds[1], date);

    var stats = await data.stats(keeper, date);
    expect(stats.completedToday, 2);
    expect(stats.totalTasksToday, 7);
    expect(stats.remainingActiveTasksToday, 5);
    expect(stats.completionPercentToday.round(), 29);

    await data.complete(taskIds[2], date);
    stats = await data.stats(keeper, date);
    expect(stats.remainingActiveTasksToday, 4);
    expect(stats.totalTasksToday, 7);

    await data.uncomplete(taskIds[2], date);
    stats = await data.stats(keeper, date);
    expect(stats.remainingActiveTasksToday, 5);
    expect(stats.totalTasksToday, 7);
  });

  test('returns no day statistics when there are no completions', () async {
    final keeper = await addKeeper();
    await data.createTask(
      DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Без отметки'),
    );

    final stats = await data.stats(keeper, DateTime.now());
    expect(stats.recentDays, isEmpty);
  });

  test('uses only the last three calendar days and skips empty days', () async {
    final keeper = await addKeeper();
    final today = normalizeOccurrenceDate(DateTime.now());
    final taskId = await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: keeper,
        title: 'История',
        createdAt: Value(today.subtract(const Duration(days: 4))),
      ),
    );
    for (final offset in [4, 2, 0]) {
      await data.complete(taskId, today.subtract(Duration(days: offset)));
    }

    var stats = await data.stats(keeper, today);
    expect(stats.recentDays, hasLength(2));
    expect(stats.recentDays.map((day) => day.date), [
      today.subtract(const Duration(days: 2)),
      today,
    ]);

    await data.complete(taskId, today.subtract(const Duration(days: 1)));
    stats = await data.stats(keeper, today);
    expect(stats.recentDays, hasLength(3));
    expect(stats.recentDays.map((day) => day.date), [
      today.subtract(const Duration(days: 2)),
      today.subtract(const Duration(days: 1)),
      today,
    ]);
  });

  test('statistics are isolated by goalkeeper', () async {
    final firstKeeper = await addKeeper();
    final secondKeeper = await addKeeper(current: false);
    final today = normalizeOccurrenceDate(DateTime.now());
    final firstTask = await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: firstKeeper,
        title: 'Первая задача',
      ),
    );
    await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: secondKeeper,
        title: 'Вторая задача',
      ),
    );
    await data.complete(firstTask, today);

    final firstStats = await data.stats(firstKeeper, today);
    expect(firstStats.totalTasksToday, 1);
    expect(firstStats.completedToday, 1);
    expect(firstStats.remainingActiveTasksToday, 0);
    expect(firstStats.completionPercentToday, 100);

    final secondStats = await data.stats(secondKeeper, today);
    expect(secondStats.totalTasksToday, 1);
    expect(secondStats.completedToday, 0);
    expect(secondStats.remainingActiveTasksToday, 1);
    expect(secondStats.completionPercentToday, 0);
  });

  testWidgets('statistics uses localized metrics and compact day cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final keeper = await addKeeper();
    final today = normalizeOccurrenceDate(DateTime.now());
    final taskId = await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: keeper,
        title: 'Статистика',
        createdAt: Value(today.subtract(const Duration(days: 3))),
      ),
    );
    for (var offset = 0; offset < 4; offset++) {
      await data.complete(taskId, today.subtract(Duration(days: offset)));
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DailyTasksScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Выполнено\nсегодня'), findsOneWidget);
    expect(find.text('Активные\nзадачи'), findsOneWidget);
    expect(find.text('Процент\nсегодня'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1/1'), findsNWidgets(3));
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('task created today is not counted in yesterday total', () async {
    final keeper = await addKeeper();
    final today = normalizeOccurrenceDate(DateTime.now());
    final oldTask = await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: keeper,
        title: 'Старая',
        createdAt: Value(today.subtract(const Duration(days: 2))),
      ),
    );
    await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: keeper,
        title: 'Новая',
        createdAt: Value(today.add(const Duration(hours: 1))),
      ),
    );
    await data.complete(oldTask, today.subtract(const Duration(days: 1)));

    final stats = await data.stats(keeper, today);
    expect(stats.recentDays.single.totalCount, 1);
  });

  test(
    'daily totals differ by task lifecycle and completions stay date-specific',
    () async {
      final keeper = await addKeeper();
      final today = normalizeOccurrenceDate(DateTime.now());
      final first = await data.createTask(
        DailyTasksCompanion.insert(
          goalkeeperId: keeper,
          title: 'Первая',
          createdAt: Value(today.subtract(const Duration(days: 2))),
        ),
      );
      final second = await data.createTask(
        DailyTasksCompanion.insert(
          goalkeeperId: keeper,
          title: 'Вторая',
          createdAt: Value(today),
        ),
      );
      await data.complete(first, today.subtract(const Duration(days: 1)));
      await data.complete(second, today);

      final stats = await data.stats(keeper, today);
      expect(stats.recentDays.map((day) => day.totalCount), [1, 2]);
      expect(stats.recentDays.map((day) => day.completedCount), [1, 1]);
    },
  );

  testWidgets('description input saves only after Save is pressed', (
    tester,
  ) async {
    final keeper = await addKeeper();
    final taskId = await data.createTask(
      DailyTasksCompanion.insert(goalkeeperId: keeper, title: 'Задача'),
    );
    final task = (await db.select(db.dailyTasks).get()).single;
    await pumpTaskForm(tester, task: task);

    const description = 'Длинное описание без сохранения при вводе';
    await tester.enterText(find.byType(TextFormField).at(1), description);
    await tester.pump();
    expect((await db.select(db.dailyTasks).get()).single.description, isNull);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final updated = (await db.select(db.dailyTasks).get()).single;
    expect(updated.id, taskId);
    expect(updated.goalkeeperId, keeper);
    expect(updated.description, description);
  });

  testWidgets(
    'create form preserves text, controllers, and focus nodes across rebuilds',
    (tester) async {
      final keeper = await addKeeper();
      await pumpTaskForm(tester);

      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(2));
      final initialEditableTexts = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      final titleController = initialEditableTexts[0].controller;
      final descriptionController = initialEditableTexts[1].controller;
      final titleFocusNode = initialEditableTexts[0].focusNode;
      final descriptionFocusNode = initialEditableTexts[1].focusNode;

      for (final title in ['Н', 'Но', 'Новая', 'Новая задача']) {
        await tester.enterText(fields.at(0), title);
        await tester.pump();
      }
      const description =
          'Первая строка описания\nВторая строка с длинным текстом для IME';
      await tester.enterText(fields.at(1), description);
      await tester.pump();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      final rebuiltEditableTexts = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      expect(rebuiltEditableTexts[0].controller, same(titleController));
      expect(rebuiltEditableTexts[1].controller, same(descriptionController));
      expect(rebuiltEditableTexts[0].focusNode, same(titleFocusNode));
      expect(rebuiltEditableTexts[1].focusNode, same(descriptionFocusNode));
      expect(titleController.text, 'Новая задача');
      expect(descriptionController.text, description);
      expect(await db.select(db.dailyTasks).get(), isEmpty);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final saved = (await db.select(db.dailyTasks).get()).single;
      expect(saved.goalkeeperId, keeper);
      expect(saved.title, 'Новая задача');
      expect(saved.description, description);
    },
  );

  testWidgets(
    'edit form applies initial values once and does not save before Save',
    (tester) async {
      final keeper = await addKeeper();
      final taskId = await data.createTask(
        DailyTasksCompanion.insert(
          goalkeeperId: keeper,
          title: 'Исходный заголовок',
          description: const Value('Исходное описание'),
        ),
      );
      final task = (await db.select(db.dailyTasks).get()).single;
      await pumpTaskForm(tester, task: task);

      final fields = find.byType(TextFormField);
      final editableTexts = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      final titleController = editableTexts[0].controller;
      final descriptionController = editableTexts[1].controller;
      expect(titleController.text, 'Исходный заголовок');
      expect(descriptionController.text, 'Исходное описание');

      await tester.enterText(fields.at(0), 'Изменённый заголовок');
      await tester.enterText(fields.at(1), 'Изменённое\nописание');
      final container = ProviderScope.containerOf(tester.element(fields.at(0)));
      await container.read(dailyTasksControllerProvider.notifier).refresh();
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(titleController.text, 'Изменённый заголовок');
      expect(descriptionController.text, 'Изменённое\nописание');
      var stored = (await db.select(db.dailyTasks).get()).single;
      expect(stored.title, 'Исходный заголовок');
      expect(stored.description, 'Исходное описание');

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      stored = (await db.select(db.dailyTasks).get()).single;
      expect(stored.id, taskId);
      expect(stored.title, 'Изменённый заголовок');
      expect(stored.description, 'Изменённое\nописание');
    },
  );

  testWidgets('Cancel does not save edit form changes', (tester) async {
    final keeper = await addKeeper();
    await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: keeper,
        title: 'Без изменений',
        description: const Value('Старое описание'),
      ),
    );
    final task = (await db.select(db.dailyTasks).get()).single;
    await pumpTaskForm(tester, task: task);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Не сохранять');
    await tester.enterText(fields.at(1), 'Не сохранять описание');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    final stored = (await db.select(db.dailyTasks).get()).single;
    expect(stored.title, 'Без изменений');
    expect(stored.description, 'Старое описание');
  });

  testWidgets('edit form fits a small viewport with the keyboard open', (
    tester,
  ) async {
    final keeper = await addKeeper();
    final taskId = await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: keeper,
        title: 'Очень длинное название задачи для маленького экрана',
        description: Value('Очень длинное описание задачи ' * 8),
      ),
    );
    final task = (await db.select(db.dailyTasks).get()).single;
    expect(task.id, taskId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: const MediaQueryData(size: Size(320, 568)),
            child: DailyTaskEditScreen(task: task),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.showKeyboard(find.byType(TextFormField).at(1));
    await tester.pump();

    expect(find.text('Save'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('task list renders without overflow', (tester) async {
    final keeper = await addKeeper();
    await data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: keeper,
        title: 'Задача с длинным названием для проверки карточки',
        description: Value('Описание задачи'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DailyTasksScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Задача с длинным названием для проверки карточки'),
      findsOneWidget,
    );
    expect(find.text('Описание задачи'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('migrates version 4 without losing goalkeeper data', () async {
    final oldExecutor = NativeDatabase.memory(
      setup: (database) {
        database.execute('''
        CREATE TABLE goalkeepers (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          uuid TEXT NOT NULL UNIQUE,
          first_name TEXT NOT NULL,
          last_name TEXT NOT NULL,
          hand TEXT NOT NULL,
          email TEXT,
          birth_date INTEGER,
          is_current INTEGER NOT NULL DEFAULT 0,
          photo_path TEXT
        )
      ''');
        database.execute(
          'CREATE TABLE matches (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, goalkeeper_id INTEGER NOT NULL, date INTEGER NOT NULL, opponent TEXT NOT NULL, score TEXT, game_time TEXT, personal_tasks TEXT, game_duration INTEGER NOT NULL DEFAULT 60, goals_conceded INTEGER NOT NULL DEFAULT 0, saves INTEGER NOT NULL DEFAULT 0, save_percentage REAL, mood_rating INTEGER, warmup_rating INTEGER, confidence_rating INTEGER, great_saves_rating INTEGER, comments TEXT, created_at INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP)',
        );
        database.execute(
          'CREATE TABLE goals (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, match_id INTEGER NOT NULL, goal_type_id INTEGER NOT NULL, to_zone_x REAL, to_zone_y REAL, from_zone_x REAL, from_zone_y REAL, created_at INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP)',
        );
        database.execute(
          "INSERT INTO goalkeepers (uuid, first_name, last_name, hand) VALUES ('legacy', 'Старый', 'Вратарь', 'right')",
        );
        database.execute('PRAGMA user_version = 4');
      },
    );
    final migrated = AppDatabase(oldExecutor);
    expect((await migrated.getAllGoalkeepers()).single.firstName, 'Старый');
    await migrated
        .into(migrated.dailyTasks)
        .insert(
          DailyTasksCompanion.insert(goalkeeperId: 1, title: 'После миграции'),
        );
    expect(await migrated.select(migrated.dailyTasks).get(), hasLength(1));
    await migrated.close();
  });
}
