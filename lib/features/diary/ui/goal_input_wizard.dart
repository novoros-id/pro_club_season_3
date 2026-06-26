import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';
import 'package:drift/drift.dart' hide Column;

class GoalInputWizard extends ConsumerStatefulWidget {
  final Matche match;
  final Goal? existingGoal;

  const GoalInputWizard({
    super.key,
    required this.match,
    this.existingGoal,
  });

  @override
  ConsumerState<GoalInputWizard> createState() => _GoalInputWizardState();
}

class _GoalInputWizardState extends ConsumerState<GoalInputWizard> {
  int _currentStep = 0;
  int _selectedGoalTypeId = 1;
  double? _toZoneX;
  double? _toZoneY;
  double? _fromZoneX;
  double? _fromZoneY;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color auxText = Color(0xFF9B9EA1);
  static const double borderRadius = 15.0;

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
      // Редактирование
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
      // Создание
      await db.insertGoal(GoalsCompanion.insert(
        matchId: widget.match.id,
        goalTypeId: _selectedGoalTypeId,
        toZoneX: Value(_toZoneX),      // ✅ Обернули в Value()
        toZoneY: Value(_toZoneY),      // ✅
        fromZoneX: Value(_fromZoneX),  // ✅
        fromZoneY: Value(_fromZoneY),  // ✅
      ));
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
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
          widget.existingGoal != null
              ? 'РЕДАКТИРОВАТЬ ГОЛ'
              : 'НОВЫЙ ГОЛ',
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
          // Индикатор прогресса
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
          // Контент шага
          Expanded(child: _buildCurrentStep()),
          // Кнопки навигации
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
                      child: const Text(
                        'НАЗАД',
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                      ),
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
                      style: const TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
          decoration: BoxDecoration(
            color: isActive ? accentColor : inputBg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive ? primaryText : auxText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 11,
            color: isActive ? primaryText : auxText,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildGoalTypeStep();
      case 1:
        return _buildToZoneStep();
      case 2:
        return _buildFromZoneStep();
      default:
        return const SizedBox();
    }
  }

  // ШАГ 1: Выбор типа гола
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
            color: isSelected ? accentColor.withOpacity(0.2) : inputBg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isSelected ? accentColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              '${goalType['id']}. ${goalType['name']}',
              style: const TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: accentColor, size: 28)
                : null,
            onTap: () {
              setState(() {
                _selectedGoalTypeId = goalType['id'];
              });
            },
          ),
        );
      },
    );
  }

  // ШАГ 2: Куда забит гол
  Widget _buildToZoneStep() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Отметь куда забит гол\n(нажми на ворота)',
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
              final RenderBox box = context.findRenderObject() as RenderBox;
              final size = box.size;
              final tapPosition = details.localPosition;
              setState(() {
                _toZoneX = tapPosition.dx / size.width;
                _toZoneY = tapPosition.dy / size.height;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/goalie.png',
                      fit: BoxFit.contain,
                      width: 300, // можно ограничить размер
                    ),
                  ),
                  if (_toZoneX != null && _toZoneY != null)
                    Positioned(
                      left: _toZoneX! * (MediaQuery.of(context).size.width - 64) - 10,
                      top: _toZoneY! * (MediaQuery.of(context).size.height - 300) - 10,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
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
      ],
    );
  }

  // ШАГ 3: Откуда бросок
  Widget _buildFromZoneStep() {
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
              final RenderBox box = context.findRenderObject() as RenderBox;
              final size = box.size;
              final tapPosition = details.localPosition;
              setState(() {
                _fromZoneX = tapPosition.dx / size.width;
                _fromZoneY = tapPosition.dy / size.height;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_hockey,
                          size: 100,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Картинка площадки',
                          style: TextStyle(color: Colors.grey.shade400, fontFamily: 'Lato'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '(assets/images/rink.png)',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontFamily: 'Lato'),
                        ),
                      ],
                    ),
                  ),
                  if (_fromZoneX != null && _fromZoneY != null)
                    Positioned(
                      left: _fromZoneX! * (MediaQuery.of(context).size.width - 64) - 10,
                      top: _fromZoneY! * (MediaQuery.of(context).size.height - 300) - 10,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E88E5),
                          shape: BoxShape.circle,
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
      ],
    );
  }
}