import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:goalkeeper_trainer/core/database/app_database.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/data/daily_tasks_data.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/logic/daily_task_date.dart';

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
    final date = DateTime(2026, 7, 20);
    await data.complete(first, date);

    final stats = await data.stats(keeper, date);
    expect(stats.total, 2);
    expect(stats.completed, 1);
    expect(stats.pending, 1);
    expect(stats.lastSevenDays, hasLength(7));
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
