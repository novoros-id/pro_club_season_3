import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/app_database.dart';
import '../../providers/analytics_filter_provider.dart';

class GoalsConcededMapScreen extends ConsumerStatefulWidget {
  const GoalsConcededMapScreen({super.key});

  @override
  ConsumerState<GoalsConcededMapScreen> createState() => _GoalsConcededMapScreenState();
}

class _GoalsConcededMapScreenState extends ConsumerState<GoalsConcededMapScreen> {
  List<Goal> _allGoals = [];
  Map<int, Matche> _matchesMap = {};
  bool _isLoading = true;

  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);

  // Пропорции картинки вратаря (как в wizard)
  static const double aspectRatio = 720 / 947;

  static const Map<int, Color> goalTypeColors = {
    1: Colors.red,
    2: Colors.orange,
    3: Colors.purple,
    4: Colors.blueGrey,
    5: Colors.brown,
    6: Colors.black,
    7: Colors.teal,
  };

  static const Map<int, String> goalTypeNames = {
    1: 'Прямой бросок',
    2: 'Бросок с передачи',
    3: 'Добивание',
    4: 'Закрывание обзора',
    5: 'Подставление',
    6: 'Буллит',
    7: 'Атака из-за ворот',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final filters = ref.read(analyticsFilterProvider);
    if (filters.selectedGoalkeeper == null || filters.startDate == null || filters.endDate == null) {
      setState(() {
        _allGoals = [];
        _isLoading = false;
      });
      return;
    }

    setState(() { _isLoading = true; });

    final db = ref.read(databaseProvider);

    final allMatches = await db.getMatchesByGoalkeeper(filters.selectedGoalkeeper!.id);

    final filteredMatches = allMatches.where((m) {
      return m.date.isAfter(filters.startDate!.subtract(const Duration(days: 1))) &&
          m.date.isBefore(filters.endDate!.add(const Duration(days: 1)));
    }).toList();

    _matchesMap = { for (var m in filteredMatches) m.id: m };

    List<Goal> loadedGoals = [];
    for (var match in filteredMatches) {
      final goals = await db.getGoalsByMatch(match.id);
      loadedGoals.addAll(goals);
    }

    setState(() {
      _allGoals = loadedGoals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(analyticsFilterProvider);
    final isLeftHanded = filters.selectedGoalkeeper?.hand == 'left';
    final goalieImage = isLeftHanded
        ? 'assets/images/goalie_l.png'
        : 'assets/images/goalie_r.png';

    final double containerWidth = MediaQuery.of(context).size.width - 32;
    final double containerHeight = containerWidth * aspectRatio;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ПРОПУЩЕННЫЕ ГОЛЫ',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allGoals.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Нет пропущенных голов\nза выбранный период.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Lato', color: auxText),
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: goalTypeNames.entries.map((entry) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: goalTypeColors[entry.key] ?? Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entry.value,
                        style: const TextStyle(fontSize: 12, fontFamily: 'Lato'),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Stack(
                children: [
                  Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        goalieImage,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  ..._allGoals.map((goal) {
                    if (goal.toZoneX == null || goal.toZoneY == null) return const SizedBox.shrink();

                    return Positioned(
                      left: goal.toZoneX! * containerWidth - 8,
                      top: goal.toZoneY! * containerHeight - 8,
                      child: GestureDetector(
                        onTap: () => _showGoalDetails(goal),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: goalTypeColors[goal.goalTypeId] ?? Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'ВСЕГО ГОЛОВ: ${_allGoals.length}',
              style: const TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDetails(Goal goal) {
    final match = _matchesMap[goal.matchId];
    if (match == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'ДЕТАЛИ ГОЛА',
          style: const TextStyle(fontFamily: 'Unbounded', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Тип:', goalTypeNames[goal.goalTypeId] ?? 'Неизвестно'),
            _detailRow('Дата:', DateFormat('dd.MM.yyyy').format(match.date)),
            _detailRow('Соперник:', match.opponent),
            _detailRow('Счёт:', match.score ?? '-'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ЗАКРЫТЬ', style: TextStyle(color: accentColor)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato')),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Lato'))),
        ],
      ),
    );
  }
}