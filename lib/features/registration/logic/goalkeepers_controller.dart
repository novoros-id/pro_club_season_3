import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart'; //
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

final goalkeepersControllerProvider =
    NotifierProvider<GoalkeepersController, List<Goalkeeper>>(
      GoalkeepersController.new,
    );

final currentGoalkeeperProvider = Provider<Goalkeeper?>((ref) {
  for (final goalkeeper in ref.watch(goalkeepersControllerProvider)) {
    if (goalkeeper.isCurrent) return goalkeeper;
  }
  return null;
});

class GoalkeepersController extends Notifier<List<Goalkeeper>> {
  late AppDatabase _db;

  @override
  List<Goalkeeper> build() {
    _db = ref.read(databaseProvider);
    _loadGoalkeepers();
    return [];
  }

  Future<void> _loadGoalkeepers() async {
    final keepers = await _db.getAllGoalkeepers();
    state = keepers;
  }

  Future<void> refresh() async {
    await _loadGoalkeepers();
  }

  Future<void> addGoalkeeper({
    required String firstName,
    required String lastName,
    required String hand,
    String? email,
    DateTime? birthDate,
    bool isCurrent = false,
  }) async {
    final uuid = const Uuid().v4();

    // Если это первый вратарь, он автоматически становится текущим
    if (state.isEmpty) isCurrent = true;

    final companion = GoalkeepersCompanion(
      uuid: Value(uuid),
      firstName: Value(firstName),
      lastName: Value(lastName),
      hand: Value(hand),
      email: Value(email),
      birthDate: Value(birthDate),
      isCurrent: Value(isCurrent),
    );

    await _db.insertGoalkeeper(companion);
    await _loadGoalkeepers();

    // Если сделали его текущим, обновляем остальных
    if (isCurrent) {
      final newKeeper = state.firstWhere((k) => k.uuid == uuid);
      await _db.setCurrentGoalkeeper(newKeeper.id);
      await _loadGoalkeepers();
    }
  }

  Future<void> deleteGoalkeeper(int id, bool isCurrent) async {
    if (isCurrent) throw Exception("Нельзя удалить текущего вратаря!");
    await _db.deleteGoalkeeper(id);
    await _loadGoalkeepers();
  }

  Future<void> makeCurrent(int id) async {
    await _db.setCurrentGoalkeeper(id);
    await _loadGoalkeepers();
  }
}
