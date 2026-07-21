import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/app_database.dart';
import '../../providers/analytics_filter_provider.dart';

class ShotOriginMapScreen extends ConsumerStatefulWidget {
  const ShotOriginMapScreen({super.key});

  @override
  ConsumerState<ShotOriginMapScreen> createState() => _ShotOriginMapScreenState();
}

class _ShotOriginMapScreenState extends ConsumerState<ShotOriginMapScreen> {
  List<Goal> _allGoals = [];
  Map<int, Matche> _matchesMap = {};
  bool _isLoading = true;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);

  // Пропорции картинки поля pole.png (2617x2094)
  static const double aspectRatio = 2094 / 2617;

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

    // 1. Получаем все игры вратаря
    final allMatches = await db.getMatchesByGoalkeeper(filters.selectedGoalkeeper!.id);

    // 2. Фильтруем игры по дате
    final filteredMatches = allMatches.where((m) {
      return m.date.isAfter(filters.startDate!.subtract(const Duration(days: 1))) &&
          m.date.isBefore(filters.endDate!.add(const Duration(days: 1)));
    }).toList();

    _matchesMap = { for (var m in filteredMatches) m.id: m };

    // 3. Загружаем голы для каждой игры
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
    // Динамические размеры как в Wizard для поля
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
          'ОТКУДА БИЛИ',
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
            'Нет данных о бросках\nза выбранный период.',
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
            // Легенда (можно добавить позже, если нужно)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E88E5), // Синий цвет для бросков
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Место броска',
                    style: TextStyle(fontSize: 12, fontFamily: 'Lato'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Карта поля
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
                        'assets/images/pole.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),

                  // Точки бросков
                  ..._allGoals.map((goal) {
                    // Используем fromZoneX/Y для места броска
                    if (goal.fromZoneX == null || goal.fromZoneY == null) return const SizedBox.shrink();

                    return Positioned(
                      left: goal.fromZoneX! * containerWidth - 8, // -8 это половина ширины точки (16/2)
                      top: goal.fromZoneY! * containerHeight - 8,
                      child: GestureDetector(
                        onTap: () => _showGoalDetails(goal),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E88E5), // Синий цвет
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
              'ВСЕГО БРОСКОВ: ${_allGoals.length}',
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
          'ДЕТАЛИ БРОСКА',
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