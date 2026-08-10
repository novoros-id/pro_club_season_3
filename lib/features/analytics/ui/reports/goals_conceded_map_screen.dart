import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math; // Для отрисовки сетки
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
      // Если хочешь показывать ТОЛЬКО прямые броски, раскомментируй строку ниже:
      // loadedGoals.addAll(goals.where((g) => g.goalTypeId == 1).toList());
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

    // ✅ ИСПОЛЬЗУЕМ ТЕ ЖЕ РАЗМЕРЫ И ФОРМУЛЫ, ЧТО В WIZARD
    final double containerWidth = MediaQuery.of(context).size.width - 32;
    final double containerHeight = containerWidth * aspectRatio;

    // 🎯 НАСТРОЙКА ЦЕНТРА ЗОН (как в GoalInputWizard)
    final double centerX = containerWidth / 2;
    final double centerY = (containerHeight / 2) + (containerHeight * 0.085); // Смещение вниз

    // Радиусы (как в GoalInputWizard)
    final double outerRadius = containerWidth * 0.51;
    final double innerRadius = containerWidth * 0.35;

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
            // ✅ ЗАГОЛОВОК ВМЕСТО ЛЕГЕНДЫ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'ИНФОРМАЦИЯ ПО ПРЯМЫМ БРОСКАМ',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF121212),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Stack(
                children: [
                  // 1. СЕТКА (Рисуем первой, чтобы была ПОД картинкой)
                  // Используем тот же ZoneGridPainter, что и в Wizard, но с другими цветами/прозрачностью
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ZoneGridPainter(
                        width: containerWidth,
                        height: containerHeight,
                        centerX: centerX,
                        centerY: centerY,
                        innerRadius: innerRadius,
                        outerRadius: outerRadius,
                      ),
                    ),
                  ),

                  // 2. КАРТИНКА ВРАТАРЯ (Рисуем второй, чтобы перекрыть сетку)
                  Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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

                  // 3. ТОЧКИ ГОЛОВ (Рисуем поверх всего)
                  ..._allGoals.map((goal) {
                    if (goal.toZoneX == null || goal.toZoneY == null) return const SizedBox.shrink();

                    // Если хочешь показывать ТОЛЬКО прямые броски, раскомментируй условие ниже:
                    // if (goal.goalTypeId != 1) return const SizedBox.shrink();

                    return Positioned(
                      left: goal.toZoneX! * containerWidth - 8,
                      top: goal.toZoneY! * containerHeight - 8,
                      child: GestureDetector(
                        onTap: () => _showGoalDetails(goal),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            // Красный цвет для прямых бросков, серый для остальных (опционально)
                            color: goal.goalTypeId == 1 ? Colors.red : Colors.grey.withOpacity(0.5),
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

// 🎨 ОТЛАДОЧНАЯ СЕТКА ЗОН (ЦВЕТНАЯ, КАК В WIZARD, НО ПОЛУПРОЗРАЧНАЯ)
class ZoneGridPainter extends CustomPainter {
  final double width;
  final double height;
  final double centerX;
  final double centerY;
  final double innerRadius;
  final double outerRadius;

  ZoneGridPainter({
    required this.width,
    required this.height,
    required this.centerX,
    required this.centerY,
    required this.innerRadius,
    required this.outerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Линии секторов (Красные, как в wizard, но полупрозрачные)
    final linePaint = Paint()
      ..color = Colors.red.withOpacity(0.4) // Полупрозрачный красный
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Внутренний круг (Синий, как в wizard)
    final innerCirclePaint = Paint()
      ..color = Colors.blue.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Внешний круг (Зеленый, как в wizard)
    final outerCirclePaint = Paint()
      ..color = Colors.green.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(centerX, centerY), outerRadius, outerCirclePaint);
    canvas.drawCircle(Offset(centerX, centerY), innerRadius, innerCirclePaint);

    // Строго вертикальная линия (12 часов)
    final double startAngleRad = -math.pi / 2;
    final double stepRad = 22.5 * math.pi / 180;

    for (int i = 0; i < 16; i++) {
      final angle = startAngleRad + i * stepRad;
      final dx = math.cos(angle) * outerRadius;
      final dy = math.sin(angle) * outerRadius;
      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(centerX + dx, centerY + dy),
        linePaint,
      );
    }

    // Точка центра (черная)
    canvas.drawCircle(Offset(centerX, centerY), 3, Paint()..color = Colors.black.withOpacity(0.5));

    // Маркер 12 часов (красный)
    canvas.drawCircle(Offset(centerX, centerY - outerRadius), 4, Paint()..color = Colors.red.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}