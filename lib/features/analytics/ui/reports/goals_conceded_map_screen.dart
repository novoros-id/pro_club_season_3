import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Для загрузки assets
import 'dart:convert'; // Для декодирования JSON
import 'dart:math' as math;
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

  // Выбранная зона для подсветки (если null - показываем все)
  String? _selectedZone;

  // Данные легенды, загружаемые из JSON
  List<Map<String, dynamic>> _zoneData = [];

  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color inputBg = Color(0xFFF2F2F7);

  // Пропорции картинки вратаря (как в wizard)
  static const double aspectRatio = 720 / 947;

  // Названия типов голов
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
    _loadZoneComments(); // Загружаем легенду
    _loadData();         // Загружаем статистику
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Если нужно перезагружать данные при смене фильтров, можно оставить это здесь,
    // но обычно достаточно loadData внутри setState или по триггеру.
    // Пока оставим как есть, loadData вызывается в initState.
  }

  // Метод загрузки комментариев из JSON
  Future<void> _loadZoneComments() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/shots_zones.json');
      final List<dynamic> data = json.decode(jsonString);

      if (mounted) {
        setState(() {
          _zoneData = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint("Ошибка загрузки легенды зон: $e");
    }
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
      _selectedZone = null;
    });
  }

  // Группировка голов по зонам
  Map<String, int> _getZoneStats() {
    Map<String, int> stats = {};
    for (var goal in _allGoals) {
      if (goal.zone != null && goal.zone!.isNotEmpty) {
        stats[goal.zone!] = (stats[goal.zone!] ?? 0) + 1;
      }
    }
    var sortedEntries = stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries);
  }

  // Получение комментария из загруженного JSON
  String _getComment(String zoneCode, String hand) {
    if (_zoneData.isEmpty) return 'Загрузка...';

    // Ищем объект в списке, где код_левша или код_правша совпадает с zoneCode
    // В зависимости от хвата вратаря, мы знаем, какой код использовать для поиска,
    // но так как zoneCode уже является конкретным кодом (например, A1 для левши),
    // мы просто ищем этот код в соответствующем поле JSON.

    final item = _zoneData.firstWhere(
          (element) {
        if (hand == 'left') {
          return element['код_левша'] == zoneCode;
        } else {
          return element['код_правша'] == zoneCode;
        }
      },
      orElse: () => {},
    );

    if (item.isNotEmpty) {
      return item['текст_для_вратаря'] ?? 'Нет описания';
    }

    return 'Нет данных для этой зоны';
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(analyticsFilterProvider);
    final isLeftHanded = filters.selectedGoalkeeper?.hand == 'left';
    final goalieImage = isLeftHanded
        ? 'assets/images/goalie_l.png'
        : 'assets/images/goalie_r.png';

    final handKey = isLeftHanded ? 'left' : 'right';
    final zoneStats = _getZoneStats();
    final totalGoals = _allGoals.where((g) => g.zone != null && g.zone!.isNotEmpty).length;

    final double containerWidth = MediaQuery.of(context).size.width - 32;
    final double containerHeight = containerWidth * aspectRatio;

    final double centerX = containerWidth / 2;
    final double centerY = (containerHeight / 2) + (containerHeight * 0.085);
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
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: inputBg,
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

                  ..._allGoals.map((goal) {
                    if (goal.toZoneX == null || goal.toZoneY == null) return const SizedBox.shrink();
                    if (goal.zone == null || goal.zone!.isEmpty) return const SizedBox.shrink();

                    final isSelected = _selectedZone == goal.zone;

                    if (_selectedZone != null && !isSelected) {
                      return Positioned(
                        left: goal.toZoneX! * containerWidth - 6,
                        top: goal.toZoneY! * containerHeight - 6,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }

                    return Positioned(
                      left: goal.toZoneX! * containerWidth - 8,
                      top: goal.toZoneY! * containerHeight - 8,
                      child: GestureDetector(
                        onTap: () => _showGoalDetails(goal),
                        child: Container(
                          width: isSelected ? 20 : 16,
                          height: isSelected ? 20 : 16,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : (goal.goalTypeId == 1 ? Colors.red : Colors.grey.withValues(alpha: 0.5)),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (zoneStats.isNotEmpty) ...[
              const Text(
                'СТАТИСТИКА ПО ЗОНАМ',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(flex: 1, child: Text('ЗОНА', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText))),
                  Expanded(flex: 1, child: Text('ГОЛЫ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText), textAlign: TextAlign.center)),
                  Expanded(flex: 3, child: Text('КОММЕНТАРИЙ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText))),
                ],
              ),
              const SizedBox(height: 8),

              ...zoneStats.entries.map((entry) {
                final zoneCode = entry.key;
                final count = entry.value;
                final comment = _getComment(zoneCode, handKey);
                final isSelected = _selectedZone == zoneCode;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedZone = isSelected ? null : zoneCode;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? accentColor.withValues(alpha: 0.1) : inputBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? accentColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            zoneCode,
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? accentColor : primaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '$count',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? accentColor : primaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            comment,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              color: primaryText,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryText,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ВСЕГО ПРОПУЩЕНО:',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$totalGoals',
                    style: const TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
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
            _detailRow('Зона:', goal.zone ?? '-'),
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

// 🎨 ОТЛАДОЧНАЯ СЕТКА ЗОН
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
    final linePaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final innerCirclePaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final outerCirclePaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(centerX, centerY), outerRadius, outerCirclePaint);
    canvas.drawCircle(Offset(centerX, centerY), innerRadius, innerCirclePaint);

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

    canvas.drawCircle(Offset(centerX, centerY), 3, Paint()..color = Colors.black.withValues(alpha: 0.5));
    canvas.drawCircle(Offset(centerX, centerY - outerRadius), 4, Paint()..color = Colors.red.withValues(alpha: 0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}