import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

// 1. Таблица вратарей
class Goalkeepers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get hand => text()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  BoolColumn get isCurrent => boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text().nullable()();
}

// 2. Таблица игр
class Matches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalkeeperId => integer().references(Goalkeepers, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get opponent => text()();
  TextColumn get score => text().nullable()();
  TextColumn get gameTime => text().nullable()();
  TextColumn get personalTasks => text().nullable()();
  IntColumn get gameDuration => integer().withDefault(const Constant(60))();
  IntColumn get goalsConceded => integer().withDefault(const Constant(0))();
  IntColumn get saves => integer().withDefault(const Constant(0))();
  RealColumn get savePercentage => real().nullable()();
  IntColumn get moodRating => integer().nullable()();
  IntColumn get warmupRating => integer().nullable()();
  IntColumn get confidenceRating => integer().nullable()();
  IntColumn get greatSavesRating => integer().nullable()();
  TextColumn get comments => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 3. НОВАЯ таблица голов
// 3. НОВАЯ таблица голов
// 3. Таблица голов
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Ссылка на игру
  IntColumn get matchId => integer().references(Matches, #id)();

  // Тип гола (1-7)
  IntColumn get goalTypeId => integer()();

  // Координаты куда забит (нормализованные 0.0 - 1.0)
  RealColumn get toZoneX => real().nullable()();
  RealColumn get toZoneY => real().nullable()();

  // Координаты откуда бросок (нормализованные 0.0 - 1.0)
  RealColumn get fromZoneX => real().nullable()();
  RealColumn get fromZoneY => real().nullable()();

  TextColumn get zone => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 4. Подключение всех таблиц
@DriftDatabase(tables: [Goalkeepers, Matches, Goals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  // ========== Методы для вратарей ==========
  Future<List<Goalkeeper>> getAllGoalkeepers() => select(goalkeepers).get();
  Future<int> insertGoalkeeper(GoalkeepersCompanion entry) => into(goalkeepers).insert(entry);
  Future<bool> updateGoalkeeper(Goalkeeper entry) => update(goalkeepers).replace(entry);
  Future<int> deleteGoalkeeper(int id) => (delete(goalkeepers)..where((tbl) => tbl.id.equals(id))).go();

  Future<void> setCurrentGoalkeeper(int newCurrentId) async {
    await transaction(() async {
      await (update(goalkeepers)..where((t) => t.isCurrent.equals(true)))
          .write(const GoalkeepersCompanion(isCurrent: Value(false)));
      await (update(goalkeepers)..where((t) => t.id.equals(newCurrentId)))
          .write(const GoalkeepersCompanion(isCurrent: Value(true)));
    });
  }

  Future<Goalkeeper?> getCurrentGoalkeeper() async {
    final list = await (select(goalkeepers)..where((t) => t.isCurrent.equals(true))).get();
    return list.isNotEmpty ? list.first : null;
  }

  // ========== Методы для игр ==========
  Future<List<Matche>> getAllMatches() => select(matches).get();
  Future<List<Matche>> getMatchesByGoalkeeper(int goalkeeperId) {
    return (select(matches)..where((m) => m.goalkeeperId.equals(goalkeeperId))).get();
  }
  Future<List<Matche>> getMatchesByDate(int goalkeeperId, DateTime date) {
    return (select(matches)
      ..where((m) => m.goalkeeperId.equals(goalkeeperId) &
      m.date.year.equals(date.year) &
      m.date.month.equals(date.month) &
      m.date.day.equals(date.day)))
        .get();
  }
  Future<int> insertMatch(MatchesCompanion match) => into(matches).insert(match);
  Future<bool> updateMatch(Matche match) => update(matches).replace(match);
  Future<int> deleteMatch(int id) => (delete(matches)..where((m) => m.id.equals(id))).go();
  Future<Matche?> getMatchById(int id) async {
    final list = await (select(matches)..where((m) => m.id.equals(id))).get();
    return list.isNotEmpty ? list.first : null;
  }

  // ========== НОВЫЕ методы для голов ==========
  Future<List<Goal>> getGoalsByMatch(int matchId) {
    return (select(goals)..where((g) => g.matchId.equals(matchId))).get();
  }

  Future<int> insertGoal(GoalsCompanion goal) => into(goals).insert(goal);

  Future<bool> updateGoal(Goal goal) => update(goals).replace(goal);

  Future<int> deleteGoal(int id) => (delete(goals)..where((g) => g.id.equals(id))).go();

  Future<void> deleteGoalsByMatch(int matchId) async {
    await (delete(goals)..where((g) => g.matchId.equals(matchId))).go();
  }
}

// 5. Инициализация БД
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'goalkeeper_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}