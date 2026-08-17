import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart' hide Column;

class SyncService {
  final AppDatabase _db;

  SyncService(this._db);

  // --- ЭКСПОРТ ДАННЫХ ---
  // Возвращает путь к созданному файлу, чтобы UI мог сам вызвать Share с правильными координатами
  Future<String?> exportData(int goalkeeperId) async {
    try {
      // 1. Получаем данные вратаря
      final keepers = await (_db.select(_db.goalkeepers)..where((t) => t.id.equals(goalkeeperId))).get();
      if (keepers.isEmpty) throw Exception("Вратарь не найден");
      final keeper = keepers.first;

      // 2. Получаем игры этого вратаря
      final matches = await _db.getMatchesByGoalkeeper(goalkeeperId);

      // Создаем карту для быстрого поиска UUID матча по его ID
      final Map<int, String> matchIdToUuid = { for (var m in matches) m.id: m.uuid };

      // 3. Получаем голы для этих игр
      List<Goal> allGoals = [];
      for (var match in matches) {
        final goals = await _db.getGoalsByMatch(match.id);
        allGoals.addAll(goals);
      }

      // 4. Получаем задачи и выполнения этого вратаря
      final tasks = await (_db.select(_db.dailyTasks)..where((t) => t.goalkeeperId.equals(goalkeeperId))).get();

      // Создаем карту для быстрого поиска UUID задачи по ее ID
      final Map<int, String> taskIdToUuid = { for (var t in tasks) t.id: t.uuid };

      List<DailyTaskCompletion> completions = [];
      if (tasks.isNotEmpty) {
        final taskIds = tasks.map((t) => t.id).toList();
        completions = await (_db.select(_db.dailyTaskCompletions)
          ..where((t) => t.taskId.isIn(taskIds))).get();
      }

      // 5. Формируем структуру JSON ВРУЧНУЮ
      final data = {
        "exportDate": DateTime.now().toIso8601String(),
        "goalkeeper": {
          "uuid": keeper.uuid,
          "firstName": keeper.firstName,
          "lastName": keeper.lastName,
          "hand": keeper.hand,
          "email": keeper.email,
          "birthDate": keeper.birthDate?.toIso8601String(),
        },
        "matches": matches.map((m) => {
          'uuid': m.uuid,
          'date': m.date.toIso8601String(),
          'opponent': m.opponent,
          'score': m.score,
          'gameTime': m.gameTime,
          'personalTasks': m.personalTasks,
          'gameDuration': m.gameDuration,
          'goalsConceded': m.goalsConceded,
          'saves': m.saves,
          'savePercentage': m.savePercentage,
          'moodRating': m.moodRating,
          'warmupRating': m.warmupRating,
          'confidenceRating': m.confidenceRating,
          'greatSavesRating': m.greatSavesRating,
          'comments': m.comments,
        }).toList(),

        "goals": allGoals.map((g) => {
          'matchUuid': matchIdToUuid[g.matchId],
          'goalTypeId': g.goalTypeId,
          'toZoneX': g.toZoneX,
          'toZoneY': g.toZoneY,
          'fromZoneX': g.fromZoneX,
          'fromZoneY': g.fromZoneY,
          'zone': g.zone,
          'fromZone': g.fromZone,
        }).toList(),

        "tasks": tasks.map((t) => {
          'uuid': t.uuid,
          'title': t.title,
          'description': t.description,
          'recurrenceType': t.recurrenceType,
          'isEnabled': t.isEnabled,
        }).toList(),

        "completions": completions.map((c) => {
          'taskUuid': taskIdToUuid[c.taskId],
          'occurrenceDate': c.occurrenceDate.toIso8601String(),
        }).toList(),
      };

      final jsonString = jsonEncode(data);

      // 6. Сохраняем во временный файл
      final tempDir = await getTemporaryDirectory();
      final fileName = "backup_${keeper.lastName}_${DateTime.now().millisecondsSinceEpoch}.json";
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonString);

      // 7. ВОЗВРАЩАЕМ ПУТЬ К ФАЙЛУ (вместо вызова Share здесь)
      return file.path;

    } catch (e) {
      debugPrint("Ошибка экспорта: $e");
      rethrow;
    }
  }

  // --- ИМПОРТ ДАННЫХ ---
  Future<void> importData() async {
    try {
      // 1. Выбираем файл
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) return;

      final filePath = result.files.single.path!;
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString);

      // 2. Запускаем транзакцию для атомарности
      await _db.transaction(() async {

        // 2.1 Вратарь: Ищем по UUID. Если нет - создаем.
        final keeperData = data['goalkeeper'];
        final localKeeperId = await _findOrCreateGoalkeeper(keeperData);

        // 2.2 Задачи: Ищем по UUID. Строим карту UUID -> LocalID
        final taskList = data['tasks'] as List;
        final Map<String, int> taskUuidToLocalId = {};
        for (var t in taskList) {
          final localTaskId = await _findOrCreateTask(t, localKeeperId);
          taskUuidToLocalId[t['uuid']] = localTaskId;
        }

        // 2.3 Игры: Ищем по UUID. Строим карту UUID -> LocalID
        final matchList = data['matches'] as List;
        final Map<String, int> matchUuidToLocalId = {};
        for (var m in matchList) {
          final localMatchId = await _findOrCreateMatch(m, localKeeperId);
          matchUuidToLocalId[m['uuid']] = localMatchId;
        }

        // 2.4 Голы: Удаляем старые для этих матчей и вставляем новые
        final goalList = data['goals'] as List;
        final Set<int> uniqueLocalMatchIds = {};
        for (var g in goalList) {
          final localMatchId = matchUuidToLocalId[g['matchUuid']];
          if (localMatchId != null) {
            uniqueLocalMatchIds.add(localMatchId);
          }
        }

        // Удалим старые голы ТОЛЬКО ОДИН РАЗ для каждого матча
        for (int matchId in uniqueLocalMatchIds) {
          await _db.deleteGoalsByMatch(matchId);
        }

        // Теперь вставляем новые голы (без удаления внутри цикла)
        for (var g in goalList) {
          final localMatchId = matchUuidToLocalId[g['matchUuid']];
          if (localMatchId != null) {
            await _db.insertGoal(GoalsCompanion.insert(
              matchId: localMatchId,
              goalTypeId: g['goalTypeId'],
              toZoneX: Value(g['toZoneX']),
              toZoneY: Value(g['toZoneY']),
              fromZoneX: Value(g['fromZoneX']),
              fromZoneY: Value(g['fromZoneY']),
              zone: Value(g['zone']),
              fromZone: Value(g['fromZone']),
            ));
          }
        }

        // 2.5 Выполнения задач
        final completionList = data['completions'] as List;
        for (var c in completionList) {
          final localTaskId = taskUuidToLocalId[c['taskUuid']];
          if (localTaskId != null) {
            await _insertCompletion(c, localTaskId);
          }
        }
      });

      debugPrint("Импорт успешно завершен!");
    } catch (e) {
      debugPrint("Ошибка импорта: $e");
      rethrow;
    }
  }

  // --- ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ---

  Future<int> _findOrCreateGoalkeeper(Map<String, dynamic> data) async {
    final uuid = data['uuid'];
    final existing = await (_db.select(_db.goalkeepers)..where((t) => t.uuid.equals(uuid))).getSingleOrNull();

    if (existing != null) {
      // Обновляем данные (имя, хват и т.д.)
      await _db.updateGoalkeeper(Goalkeeper(
        id: existing.id,
        uuid: uuid,
        firstName: data['firstName'],
        lastName: data['lastName'],
        hand: data['hand'],
        email: data['email'],
        birthDate: data['birthDate'] != null ? DateTime.parse(data['birthDate']) : null,
        isCurrent: existing.isCurrent,
        photoPath: existing.photoPath,
      ));
      return existing.id;
    } else {
      return await _db.insertGoalkeeper(GoalkeepersCompanion.insert(
        uuid: uuid,
        firstName: data['firstName'],
        lastName: data['lastName'],
        hand: data['hand'],
        email: Value(data['email']),
        birthDate: Value(data['birthDate'] != null ? DateTime.parse(data['birthDate']) : null),
        isCurrent: const Value(false),
      ));
    }
  }

  Future<int> _findOrCreateMatch(Map<String, dynamic> data, int keeperId) async {
    final uuid = data['uuid'];
    final existing = await (_db.select(_db.matches)..where((t) => t.uuid.equals(uuid))).getSingleOrNull();

    if (existing != null) {
      // Обновляем существующую игру
      await _db.updateMatch(Matche(
        id: existing.id,
        goalkeeperId: keeperId,
        uuid: uuid,
        date: DateTime.parse(data['date']),
        opponent: data['opponent'],
        score: data['score'],
        gameTime: data['gameTime'],
        personalTasks: data['personalTasks'],
        gameDuration: data['gameDuration'],
        goalsConceded: data['goalsConceded'],
        saves: data['saves'],
        savePercentage: data['savePercentage'],
        moodRating: data['moodRating'],
        warmupRating: data['warmupRating'],
        confidenceRating: data['confidenceRating'],
        greatSavesRating: data['greatSavesRating'],
        comments: data['comments'],
        createdAt: existing.createdAt,
      ));
      return existing.id;
    } else {
      return await _db.insertMatch(MatchesCompanion.insert(
        uuid: uuid,
        goalkeeperId: keeperId,
        date: DateTime.parse(data['date']),
        opponent: data['opponent'],
        score: Value(data['score']),
        gameTime: Value(data['gameTime']),
        personalTasks: Value(data['personalTasks']),
        gameDuration: Value(data['gameDuration']),
        goalsConceded: Value(data['goalsConceded']),
        saves: Value(data['saves']),
        savePercentage: Value(data['savePercentage']),
        moodRating: Value(data['moodRating']),
        warmupRating: Value(data['warmupRating']),
        confidenceRating: Value(data['confidenceRating']),
        greatSavesRating: Value(data['greatSavesRating']),
        comments: Value(data['comments']),
      ));
    }
  }

  Future<int> _findOrCreateTask(Map<String, dynamic> data, int keeperId) async {
    final uuid = data['uuid'];
    final existing = await (_db.select(_db.dailyTasks)..where((t) => t.uuid.equals(uuid))).getSingleOrNull();

    if (existing != null) return existing.id;

    return await _db.into(_db.dailyTasks).insert(DailyTasksCompanion.insert(
      uuid: uuid,
      goalkeeperId: keeperId,
      title: data['title'],
      description: Value(data['description']),
      recurrenceType: Value(data['recurrenceType']),
      isEnabled: Value(data['isEnabled']),
    ));
  }

  Future<void> _insertGoal_del(Map<String, dynamic> data, int localMatchId) async {
    // Стратегия: Удаляем все голы для этой игры перед вставкой новых из файла.
    await _db.deleteGoalsByMatch(localMatchId);

    await _db.insertGoal(GoalsCompanion.insert(
      matchId: localMatchId,
      goalTypeId: data['goalTypeId'],
      toZoneX: Value(data['toZoneX']),
      toZoneY: Value(data['toZoneY']),
      fromZoneX: Value(data['fromZoneX']),
      fromZoneY: Value(data['fromZoneY']),
      zone: Value(data['zone']),
      fromZone: Value(data['fromZone']),
    ));
  }

  Future<void> _insertCompletion(Map<String, dynamic> data, int localTaskId) async {
    final date = DateTime.parse(data['occurrenceDate']);
    // Проверяем, нет ли уже такого выполнения на эту дату
    final existing = await (_db.select(_db.dailyTaskCompletions)
      ..where((t) => t.taskId.equals(localTaskId) & t.occurrenceDate.equals(date))).getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.dailyTaskCompletions).insert(DailyTaskCompletionsCompanion.insert(
        taskId: localTaskId,
        occurrenceDate: date,
      ));
    }
  }
}