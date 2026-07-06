import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';
import 'goal_input_wizard.dart';

class GoalListScreen extends ConsumerStatefulWidget {
  final Matche match;
  final String hand; // ✅ Добавляем поле для хвата

  const GoalListScreen({super.key, required this.match, this.hand = 'right',});

  @override
  ConsumerState<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends ConsumerState<GoalListScreen> {
  List<Goal> _goals = [];
  bool _isLoading = true;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color darkButton = Color(0xFF121212);
  static const double borderRadius = 15.0;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final db = ref.read(databaseProvider);
    final goals = await db.getGoalsByMatch(widget.match.id);
    setState(() {
      _goals = goals;
      _isLoading = false;
    });
  }

  Future<void> _addGoal() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInputWizard(match: widget.match,  hand: widget.hand, ),
      ),
    );
    if (result == true) {
      await _loadGoals();
    }
  }

  Future<void> _editGoal(Goal goal) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInputWizard(
          match: widget.match,
          existingGoal: goal,
          hand: widget.hand,
        ),
      ),
    );
    if (result == true) {
      await _loadGoals();
    }
  }

  Future<void> _deleteGoal(Goal goal) async {
    final db = ref.read(databaseProvider);
    await db.deleteGoal(goal.id);
    await _loadGoals();
  }

  String _getGoalTypeName(int typeId) {
    const types = {
      1: 'Прямой бросок',
      2: 'Бросок с передачи',
      3: 'Добивание',
      4: 'Закрывание обзора',
      5: 'Подставление',
      6: 'Выход 1 на 1 (буллит)',
      7: 'Атака из-за ворот',
    };
    return types[typeId] ?? 'Неизвестно';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ГОЛЫ',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            Text(
              'Игра с ${widget.match.opponent}',
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 12,
                color: auxText,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _goals.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_hockey, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Голов ещё нет',
              style: TextStyle(
                fontFamily: 'Lato',
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Нажмите + чтобы добавить',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontFamily: 'Lato'),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _goals.length,
        itemBuilder: (context, index) {
          final goal = _goals[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                ),
              ),
              title: Text(
                _getGoalTypeName(goal.goalTypeId),
                style: const TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  if (goal.toZoneX != null && goal.toZoneY != null)
                    Text(
                      '🎯 Куда: (${goal.toZoneX!.toStringAsFixed(2)}, ${goal.toZoneY!.toStringAsFixed(2)})',
                      style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: auxText),
                    ),
                  if (goal.fromZoneX != null && goal.fromZoneY != null)
                    Text(
                      '📍 Откуда: (${goal.fromZoneX!.toStringAsFixed(2)}, ${goal.fromZoneY!.toStringAsFixed(2)})',
                      style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: auxText),
                    ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') _editGoal(goal);
                  if (value == 'delete') _deleteGoal(goal);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Удалить', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              onTap: () => _editGoal(goal),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 16),
        child: FloatingActionButton.extended(
          onPressed: _addGoal,
          backgroundColor: darkButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          label: const Text(
            'ДОБАВИТЬ ГОЛ',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}