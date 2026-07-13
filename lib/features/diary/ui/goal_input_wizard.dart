import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math; // Для расчетов углов и радиусов
import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;

class GoalInputWizard extends ConsumerStatefulWidget {
  final Matche match;
  final Goal? existingGoal;
  final String hand; // Хват вратаря ('left' или 'right')

  const GoalInputWizard({
    super.key,
    required this.match,
    this.existingGoal,
    this.hand = 'right',
  });

  @override
  ConsumerState<GoalInputWizard> createState() => _GoalInputWizardState();
}

class _GoalInputWizardState extends ConsumerState<GoalInputWizard> {
  final GlobalKey _rinkContainerKey = GlobalKey(); // Ключ для контейнера с полем
  int _currentStep = 0;
  int _selectedGoalTypeId = 1;
  double? _toZoneX;
  double? _toZoneY;
  double? _fromZoneX;
  double? _fromZoneY;

  // Флаг для отображения отладочной сетки
  bool _showDebugGrid = true;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color auxText = Color(0xFF9B9EA1);
  static const double borderRadius = 15.0;

  // Пропорции картинки вратаря (947x720)
  static const double aspectRatio = 720 / 947;

  final List<Map<String, dynamic>> _goalTypes = [
    {'id': 1, 'name': 'Прямой бросок'},
    {'id': 2, 'name': 'Бросок с передачи'},
    {'id': 3, 'name': 'Добивание'},
    {'id': 4, 'name': 'Закрывание обзора'},
    {'id': 5, 'name': 'Подставление'},
    {'id': 6, 'name': 'Выход 1 на 1 (буллит)'},
    {'id': 7, 'name': 'Атака из-за ворот'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      _selectedGoalTypeId = widget.existingGoal!.goalTypeId;
      _toZoneX = widget.existingGoal!.toZoneX;
      _toZoneY = widget.existingGoal!.toZoneY;
      _fromZoneX = widget.existingGoal!.fromZoneX;
      _fromZoneY = widget.existingGoal!.fromZoneY;
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _saveGoal();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _saveGoal() async {
    final db = ref.read(databaseProvider);
    if (widget.existingGoal != null) {
      final updated = Goal(
        id: widget.existingGoal!.id,
        matchId: widget.match.id,
        goalTypeId: _selectedGoalTypeId,
        toZoneX: _toZoneX,
        toZoneY: _toZoneY,
        fromZoneX: _fromZoneX,
        fromZoneY: _fromZoneY,
        createdAt: widget.existingGoal!.createdAt,
      );
      await db.updateGoal(updated);
    } else {
      await db.insertGoal(GoalsCompanion.insert(
        matchId: widget.match.id,
        goalTypeId: _selectedGoalTypeId,
        toZoneX: Value(_toZoneX),
        toZoneY: Value(_toZoneY),
        fromZoneX: Value(_fromZoneX),
        fromZoneY: Value(_fromZoneY),
      ));
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  // ✅ МЕТОД РАСЧЕТА ЗОНЫ (теперь принимает размеры контейнера)
  // ✅ ОБНОВЛЕННЫЙ МЕТОД: Принимает радиусы явно
  String? _calculateZone(
      double normalizedX,
      double normalizedY,
      double width,
      double height,
      double centerX,
      double centerY,
      double maxRadius,   // ✅ Добавили параметр
      double innerRadius, // ✅ Добавили параметр
      ) {
    double px = normalizedX * width;
    double py = normalizedY * height;

    double dx = px - centerX;
    double dy = py - centerY;
    double dist = math.sqrt(dx * dx + dy * dy);

    // ✅ Используем переданные радиусы, а не хардкод
    if (dist > maxRadius) return null;

    String ring = (dist < innerRadius) ? '2' : '1';

    // Угол от вертикали (12 часов) по часовой стрелке
    double angleRad = math.atan2(dx, -dy);
    double angleDeg = angleRad * 180 / math.pi;
    if (angleDeg < 0) angleDeg += 360;

    const List<String> sectors = [
      'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
      'N', 'O', 'P', 'A', 'B', 'C', 'D', 'E'
    ];

    int sectorIndex = (angleDeg / 22.5).floor();
    if (sectorIndex >= sectors.length) sectorIndex = 0;

    return '${sectors[sectorIndex]}$ring';
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
          onPressed: _previousStep,
        ),
        title: Text(
          widget.existingGoal != null ? 'РЕДАКТИРОВАТЬ ГОЛ' : 'НОВЫЙ ГОЛ',
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildStepIndicator(1, 'Тип'),
                Expanded(child: Container(height: 2, color: _currentStep >= 1 ? accentColor : Colors.grey.shade300)),
                _buildStepIndicator(2, 'В ворота'),
                Expanded(child: Container(height: 2, color: _currentStep >= 2 ? accentColor : Colors.grey.shade300)),
                _buildStepIndicator(3, 'Откуда'),
              ],
            ),
          ),
          Expanded(child: _buildCurrentStep()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: primaryText),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text('НАЗАД', style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.w600, color: primaryText)),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: _currentStep > 0 ? 2 : 1,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryText,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    child: Text(
                      _currentStep == 2 ? 'ГОТОВО' : 'ДАЛЕЕ',
                      style: const TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = step <= _currentStep + 1;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: isActive ? accentColor : inputBg, shape: BoxShape.circle),
          child: Center(child: Text('$step', style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? primaryText : auxText))),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontFamily: 'Unbounded', fontSize: 11, color: isActive ? primaryText : auxText, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildGoalTypeStep();
      case 1: return _buildToZoneStep();
      case 2: return _buildFromZoneStep();
      default: return const SizedBox();
    }
  }

  Widget _buildGoalTypeStep() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _goalTypes.length,
      itemBuilder: (context, index) {
        final goalType = _goalTypes[index];
        final isSelected = _selectedGoalTypeId == goalType['id'];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected ? accentColor.withValues(alpha: 0.2) : inputBg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: isSelected ? accentColor : Colors.transparent, width: 2),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text('${goalType['id']}. ${goalType['name']}', style: const TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.w600, color: primaryText)),
            trailing: isSelected ? const Icon(Icons.check_circle, color: accentColor, size: 28) : null,
            onTap: () => setState(() => _selectedGoalTypeId = goalType['id']),
          ),
        );
      },
    );
  }

  // ШАГ 2: Куда забит гол
  // ШАГ 2: Куда забит гол
  Widget _buildToZoneStep() {
    final String goalieImage = widget.hand == 'left'
        ? 'assets/images/goalie_l.png'
        : 'assets/images/goalie_r.png';

    // Динамический размер контейнера (растягиваем на ширину экрана)
    final double containerWidth = MediaQuery.of(context).size.width - 32;
    final double containerHeight = containerWidth * aspectRatio;

    // 🎯 НАСТРОЙКА ЦЕНТРА ЗОН
    final double centerX = containerWidth / 2;
    // Сдвиг центра вниз (подбирай это число, если сетка не совпадает с картинкой)
    // 0.085 означает сдвиг на 8.5% высоты вниз от середины
    final double centerY = (containerHeight / 2) + (containerHeight * 0.085);

    // Радиусы пропорциональны ширине (должны совпадать с теми, что в Painter!)
    final double outerRadius = containerWidth * 0.51;
    final double innerRadius = containerWidth * 0.35;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Отметь куда забит гол', style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.w600, color: primaryText)),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_showDebugGrid ? Icons.grid_on : Icons.grid_off, color: _showDebugGrid ? accentColor : auxText),
                onPressed: () => setState(() => _showDebugGrid = !_showDebugGrid),
                tooltip: 'Показать/скрыть сетку зон',
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text('(нажми на ворота)', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText), textAlign: TextAlign.center),
        ),
        Expanded(
          child: GestureDetector(
            onTapDown: (details) {
              // Получаем реальные размеры и позицию контейнера через GlobalKey
              final RenderBox? box = _imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
              if (box == null) return;

              final Offset containerOffset = box.localToGlobal(Offset.zero);

              // Координаты нажатия относительно левого верхнего угла контейнера
              final double relativeX = details.globalPosition.dx - containerOffset.dx;
              final double relativeY = details.globalPosition.dy - containerOffset.dy;

              // Нормализуем координаты (от 0.0 до 1.0)
              final double normalizedX = relativeX / box.size.width;
              final double normalizedY = relativeY / box.size.height;

              if (normalizedX >= 0 && normalizedX <= 1 && normalizedY >= 0 && normalizedY <= 1) {
                setState(() {
                  _toZoneX = normalizedX;
                  _toZoneY = normalizedY;

                  // ✅ ВАЖНО: Передаем вычисленные радиусы в метод расчета!
                  _currentZone = _calculateZone(
                    normalizedX,
                    normalizedY,
                    box.size.width,
                    box.size.height,
                    centerX,
                    centerY,
                    outerRadius,   // Передаем внешний радиус
                    innerRadius,   // Передаем внутренний радиус
                  );
                });
              }
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                key: _imageContainerKey, // Ключ для точных координат
                width: containerWidth,
                height: containerHeight,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(borderRadius), border: Border.all(color: Colors.grey.shade300)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Image.asset(goalieImage, fit: BoxFit.contain, alignment: Alignment.bottomCenter),
                    ),

                    // ✅ ОТЛАДОЧНАЯ СЕТКА (использует те же centerX, centerY и радиусы)
                    if (_showDebugGrid)
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

                    // Маркер попадания (шайба)
                    if (_toZoneX != null && _toZoneY != null)
                      Positioned(
                        left: _toZoneX! * containerWidth - 12,
                        top: _toZoneY! * containerHeight - 12,
                        child: Container(
                          width: 24, height: 24,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]),
                          child: const Icon(Icons.sports_hockey, color: primaryText, size: 16),
                        ),
                      ),

                    // Текст зоны
                    if (_currentZone != null && _toZoneX != null && _toZoneY != null)
                      Positioned(
                        left: _toZoneX! * containerWidth - 20,
                        top: _toZoneY! * containerHeight + 18,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
                          child: Text(_currentZone!, style: const TextStyle(fontFamily: 'Unbounded', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Глобальный ключ для точного определения координат контейнера
  final GlobalKey _imageContainerKey = GlobalKey();
  String? _currentZone;

  Widget _buildFromZoneStep() {
    // Динамический размер контейнера под поле
    final double containerWidth = MediaQuery.of(context).size.width - 32;
    // Пропорции картинки pole.png (2617x2094)
    final double containerHeight = containerWidth * (2094 / 2617);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Отметь откуда был бросок\n(нажми на площадку)',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTapDown: (details) {
              // Получаем координаты относительно контейнера с полем
              final RenderBox? box = _rinkContainerKey.currentContext?.findRenderObject() as RenderBox?;
              if (box == null) return;

              final Offset containerOffset = box.localToGlobal(Offset.zero);
              final double relativeX = details.globalPosition.dx - containerOffset.dx;
              final double relativeY = details.globalPosition.dy - containerOffset.dy;

              final double normalizedX = relativeX / box.size.width;
              final double normalizedY = relativeY / box.size.height;

              if (normalizedX >= 0 && normalizedX <= 1 && normalizedY >= 0 && normalizedY <= 1) {
                setState(() {
                  _fromZoneX = normalizedX;
                  _fromZoneY = normalizedY;
                });
              }
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                key: _rinkContainerKey, // Привязываем ключ
                width: containerWidth,
                height: containerHeight,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Картинка поля
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/pole.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),

                    // Маркер броска (синяя точка)
                    if (_fromZoneX != null && _fromZoneY != null)
                      Positioned(
                        left: _fromZoneX! * containerWidth - 12,
                        top: _fromZoneY! * containerHeight - 12,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E88E5), // Синий цвет
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 🎨 ОТЛАДОЧНАЯ СЕТКА ЗОН (с динамическими размерами)
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
      ..color = Colors.red.withOpacity(0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final innerCirclePaint = Paint()
      ..color = Colors.blue.withOpacity(0.7)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final outerCirclePaint = Paint()
      ..color = Colors.green.withOpacity(0.7)
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

    // Точка центра и маркер 12 часов
    canvas.drawCircle(Offset(centerX, centerY), 3, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(centerX, centerY - outerRadius), 4, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}