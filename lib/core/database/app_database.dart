import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

// 1. Определение таблицы
class Goalkeepers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get hand => text()(); // 'left' or 'right'
  TextColumn get email => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  BoolColumn get isCurrent => boolean().withDefault(const Constant(false))();
  TextColumn get photoPath => text().nullable()();
}

// 2. Подключение таблицы к базе
@DriftDatabase(tables: [Goalkeepers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // --- Методы работы с данными ---

  // ✅ ИСПРАВЛЕНО: GoalkeeperData -> Goalkeeper
  Future<List<Goalkeeper>> getAllGoalkeepers() => select(goalkeepers).get();

  Future<int> insertGoalkeeper(GoalkeepersCompanion entry) =>
      into(goalkeepers).insert(entry);

  // ✅ ИСПРАВЛЕНО: GoalkeeperData -> Goalkeeper
  Future<bool> updateGoalkeeper(Goalkeeper entry) =>
      update(goalkeepers).replace(entry);

  Future<int> deleteGoalkeeper(int id) =>
      (delete(goalkeepers)..where((tbl) => tbl.id.equals(id))).go();

  // Транзакция смены текущего вратаря
  Future<void> setCurrentGoalkeeper(int newCurrentId) async {
    await transaction(() async {
      // Сбрасываем флаг у всех
      await (update(goalkeepers)..where((t) => t.isCurrent.equals(true)))
          .write(const GoalkeepersCompanion(isCurrent: Value(false)));

      // Устанавливаем флаг у нового
      await (update(goalkeepers)..where((t) => t.id.equals(newCurrentId)))
          .write(const GoalkeepersCompanion(isCurrent: Value(true)));
    });
  }

  // ✅ ИСПРАВЛЕНО: GoalkeeperData -> Goalkeeper
  Future<Goalkeeper?> getCurrentGoalkeeper() async {
    final list = await (select(goalkeepers)..where((t) => t.isCurrent.equals(true))).get();
    return list.isNotEmpty ? list.first : null;
  }
}

// 3. Инициализация соединения с БД
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'goalkeeper_db.sqlite'));

    // Используем NativeDatabase из пакета drift/native.dart
    return NativeDatabase.createInBackground(file);
  });
}