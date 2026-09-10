import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color inputBg = Color(0xFFF2F2F7);

  // Пропорции картинки вратаря (как в wizard)
  static const double aspectRatio = 720 / 947;

  // Названия типов голов (добавлено обратно, так как используется в диалоге)
  static const Map<int, String> goalTypeNames = {
    1: 'Прямой бросок',
    2: 'Бросок с передачи',
    3: 'Добивание',
    4: 'Закрывание обзора',
    5: 'Подставление',
    6: 'Буллит',
    7: 'Атака из-за ворот',
  };

  // Карта комментариев по зонам (Код зоны -> Текст для Левши / Правши)
  // Данные взяты из Excel файла
  static const Map<String, Map<String, String>> _zoneComments = {
    'A1': {'left': 'Гол прошёл над щитком со стороны блина, сбоку. Обрати внимание на реагирование и наклон корпуса в сторону броска — добавь резкости руке и доверься инстинкту.', 'right': 'Гол над щитком со стороны ловушки, сбоку. Реагируй активнее, наклон корпуса в сторону броска. Проверь — не высоко ли держишь ловушку в стойке.'},
    'A2': {'left': 'Шайба зашла у корпуса со стороны блина, под прижатой рукой. Держи руки плотнее, локоть к корпусу, следи за шайбой и лови в одно движение.', 'right': 'Шайба зашла у корпуса со стороны ловушки, под прижатой рукой. Руки плотнее, локоть к корпусу, следи за шайбой и лови в одно движение.'},
    'B1': {'left': 'Гол в стороне от блина. Проверь реагирование и расположение — возможно, стоишь слишком глубоко или поздно реагируешь на бросок.', 'right': 'Гол в стороне от ловушки. Проверь реагирование и расположение — не стоишь ли глубоко, реагируй раньше.'},
    'B2': {'left': 'Шайба прошла подмышкой со стороны блина — «сквозь тебя». Обрати внимание на стойку: возможно, руки располагаются слишком широко и ты не успеваешь их прижать. Держи плотность и локоть у корпуса.', 'right': 'Как H2: прошло подмышкой со стороны ловушки. Стойка плотнее, локоть к корпусу, не пускай сквозь себя.'},
    'C1': {'left': 'Гол чуть выше блина. Поработай над чтением траектории и координацией руки — реагируй активнее по полёту шайбы.', 'right': 'Гол чуть выше ловушки. Поработай над чтением траектории и координацией руки. Проверь положение ловушки в стойке.'},
    'C2': {'left': 'Как B2: прошло подмышкой со стороны блина. Стойка плотнее, локоть к корпусу, не давай шайбе идти сквозь тебя.', 'right': 'Шайба прошла подмышкой со стороны ловушки — «сквозь тебя». Обрати внимание на стойку: возможно, руки широко и ты не успеваешь их прижать. Держи плотность и локоть у корпуса.'},
    'D1': {'left': 'Гол в верх ворот со стороны блина. Реагируй активнее блином и локтем, помогай телом. Проверь — не садишься ли рано и глубоко, выкатывайся навстречу броску.', 'right': 'Гол в верх ворот со стороны ловушки. Активнее лови и реагируй ловушкой и локтем, добавь тело. Проверь, не садишься ли рано.'},
    'D2': {'left': 'Шайба зашла рядом с тобой со стороны блина. Работай локтями и телом, доверься инстинкту — если стоял на позиции, вопрос к плотности.', 'right': 'Шайба прошла рядом со стороны ловушки. Локтями и телом, доверься инстинкту — вопрос к плотности.'},
    'E1': {'left': 'Гол в верх ворот по центру. Активнее реагируй плечом и локтем, добавь тело. Возможно, рано садишься — держись выше в стойке.', 'right': 'Гол в верх ворот. Реагируй плечом и локтем, помогай телом, не садись раньше времени.'},
    'E2': {'left': 'Шайба прошла близко по центру сверху. Плотнее корпусом и локтями, лови момент броска.', 'right': 'Шайба зашла рядом с тобой сверху. Работай плечом, локтями и телом — держи плотность.'},
    'F1': {'left': 'Гол в верх ворот. Реагируй плечом и локтем, помогай телом, не садись раньше времени.', 'right': 'Гол в верх ворот со стороны блина. Реагируй активнее блином и локтем, помогай телом. Проверь — не садишься ли рано и глубоко, выкатывайся навстречу броску.'},
    'F2': {'left': 'Шайба зашла рядом с тобой сверху. Работай плечом, локтями и телом — держи плотность.', 'right': 'Шайба зашла рядом с тобой со стороны блина. Работай локтями и телом, доверься инстинкту — если стоял на позиции, вопрос к плотности.'},
    'G1': {'left': 'Гол в верх ворот со стороны ловушки. Активнее лови и реагируй ловушкой и локтем, добавь тело. Проверь, не садишься ли рано.', 'right': 'Гол в верх ворот со стороны блина. Реагируй активнее блином и локтем, помогай телом. Проверь — не садишься ли рано и глубоко, выкатывайся навстречу броску.'},
    'G2': {'left': 'Шайба прошла рядом со стороны ловушки. Локтями и телом, доверься инстинкту — вопрос к плотности.', 'right': 'Шайба зашла рядом с тобой со стороны блина. Работай локтями и телом, доверься инстинкту — если стоял на позиции, вопрос к плотности.'},
    'H1': {'left': 'Гол чуть выше ловушки. Поработай над чтением траектории и координацией руки. Проверь положение ловушки в стойке.', 'right': 'Гол чуть выше блина. Поработай над чтением траектории и координацией руки — реагируй активнее по полёту шайбы.'},
    'H2': {'left': 'Шайба прошла подмышкой со стороны ловушки — «сквозь тебя». Обрати внимание на стойку: возможно, руки широко и ты не успеваешь их прижать. Держи плотность и локоть у корпуса.', 'right': 'Как B2: прошло подмышкой со стороны блина. Стойка плотнее, локоть к корпусу, не давай шайбе идти сквозь тебя.'},
    'I1': {'left': 'Гол в стороне от ловушки. Проверь реагирование и расположение — не стоишь ли глубоко, реагируй раньше.', 'right': 'Гол в стороне от блина. Проверь реагирование и расположение — возможно, стоишь слишком глубоко или поздно реагируешь на бросок.'},
    'I2': {'left': 'Как H2: прошло подмышкой со стороны ловушки. Стойка плотнее, локоть к корпусу, не пускай сквозь себя.', 'right': 'Шайба прошла подмышкой со стороны блина — «сквозь тебя». Обрати внимание на стойку: возможно, руки располагаются слишком широко и ты не успеваешь их прижать. Держи плотность и локоть у корпуса.'},
    'J1': {'left': 'Гол над щитком со стороны ловушки, сбоку. Реагируй активнее, наклон корпуса в сторону броска. Проверь — не высоко ли держишь ловушку в стойке.', 'right': 'Гол прошёл над щитком со стороны блина, сбоку. Обрати внимание на реагирование и наклон корпуса в сторону броска — добавь резкости руке и доверься инстинкту.'},
    'J2': {'left': 'Шайба зашла у корпуса со стороны ловушки, под прижатой рукой. Руки плотнее, локоть к корпусу, следи за шайбой и лови в одно движение.', 'right': 'Шайба зашла у корпуса со стороны блина, под прижатой рукой. Держи руки плотнее, локоть к корпусу, следи за шайбой и лови в одно движение.'},
    'K1': {'left': 'Гол в нижний угол со стороны ловушки. Тянись щитком до угла, не проваливайся слишком глубоко — держи угол перекрытым.', 'right': 'Гол в нижний угол со стороны блина. Тянись щитком до угла, не играй слишком глубоко.'},
    'K2': {'left': 'Низ у корпуса со стороны ловушки — обычно закрываешь телом и щитком. Держи плотнее, чтобы не прошло подмышкой.', 'right': 'Низ у корпуса со стороны блина — держи плотность, не пускай подмышкой.'},
    'L1': {'left': 'Гол низом со стороны ловушки. Успевай садиться на щитки, не давай им расходиться. Работай стойкой и реакцией, не спеши ложиться.', 'right': 'Гол низом со стороны блина. Успевай садиться на щитки, не давай им расходиться — держи стойку и реакцию. В эту зону любят бросать, будь готов.'},
    'L2': {'left': 'Низ у корпуса со стороны ловушки — держи плотность, чтобы не прошло между ног или щитков.', 'right': 'Низ у корпуса со стороны блина — держи плотнее, чтобы не прошло между ног.'},
    'M1': {'left': 'Эта зона не наносится на карту.', 'right': 'Эта зона не наносится на карту.'},
    'M2': {'left': 'Шайба между ног (5-hole). Проверь, на месте ли клюшка в момент броска, и технику опускания на щитки. Если такое редко — не страшно.', 'right': 'Прошло низом/между ног. Держи плотность и следи за техникой опускания на щитки.'},
    'N1': {'left': 'Эта зона не наносится на карту.', 'right': 'Эта зона не наносится на карту.'},
    'N2': {'left': 'Прошло низом/между ног. Держи плотность и следи за техникой опускания на щитки.', 'right': 'Шайба между ног (5-hole). Проверь, на месте ли клюшка в момент броска, и технику опускания на щитки. Если такое редко — не страшно.'},
    'O1': {'left': 'Гол низом со стороны блина. Успевай садиться на щитки, не давай им расходиться — держи стойку и реакцию. В эту зону любят бросать, будь готов.', 'right': 'Гол низом со стороны ловушки. Успевай садиться на щитки, не давай им расходиться. Работай стойкой и реакцией, не спеши ложиться.'},
    'O2': {'left': 'Низ у корпуса со стороны блина — держи плотнее, чтобы не прошло между ног.', 'right': 'Низ у корпуса со стороны ловушки — держи плотность, чтобы не прошло между ног или щитков.'},
    'P1': {'left': 'Гол в нижний угол со стороны блина. Тянись щитком до угла, не играй слишком глубоко.', 'right': 'Гол в нижний угол со стороны ловушки. Тянись щитком до угла, не проваливайся слишком глубоко — держи угол перекрытым.'},
    'P2': {'left': 'Низ у корпуса со стороны блина — держи плотность, не пускай подмышкой.', 'right': 'Низ у корпуса со стороны ловушки — обычно закрываешь телом и щитком. Держи плотнее, чтобы не прошло подмышкой.'},
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
      _selectedZone = null; // Сброс выбора при перезагрузке
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
    // Сортируем по убыванию количества
    var sortedEntries = stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries);
  }

  String _getComment(String zoneCode, String hand) {
    final zoneData = _zoneComments[zoneCode];
    if (zoneData == null) return 'Нет данных для этой зоны';

    // hand может быть 'left' или 'right'
    return zoneData[hand] ?? 'Нет данных';
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
                  // 1. СЕТКА
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

                  // 2. КАРТИНКА ВРАТАРЯ
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

                  // 3. ТОЧКИ ГОЛОВ (С ПОДСВЕТКОЙ)
                  ..._allGoals.map((goal) {
                    if (goal.toZoneX == null || goal.toZoneY == null) return const SizedBox.shrink();
                    if (goal.zone == null || goal.zone!.isEmpty) return const SizedBox.shrink();

                    final isSelected = _selectedZone == goal.zone;

                    // Если выбрана зона, то невыбранные делаем прозрачными
                    if (_selectedZone != null && !isSelected) {
                      return Positioned(
                        left: goal.toZoneX! * containerWidth - 6,
                        top: goal.toZoneY! * containerHeight - 6,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3), // Исправлено withOpacity
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
                          width: isSelected ? 20 : 16, // Увеличиваем выбранную точку
                          height: isSelected ? 20 : 16,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : (goal.goalTypeId == 1 ? Colors.red : Colors.grey.withValues(alpha: 0.5)), // Исправлено withOpacity
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }), // Убран .toList() так как он не нужен в spread (...)

                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- ТАБЛИЦА СТАТИСТИКИ ПО ЗОНАМ ---
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

              // Заголовки таблицы
              Row(
                children: [
                  Expanded(flex: 1, child: Text('ЗОНА', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText))),
                  Expanded(flex: 1, child: Text('ГОЛЫ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText), textAlign: TextAlign.center)),
                  Expanded(flex: 3, child: Text('КОММЕНТАРИЙ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText))),
                ],
              ),
              const SizedBox(height: 8),

              // Список зон
              ...zoneStats.entries.map((entry) {
                final zoneCode = entry.key;
                final count = entry.value;
                final comment = _getComment(zoneCode, handKey);
                final isSelected = _selectedZone == zoneCode;

                return InkWell(
                  onTap: () {
                    setState(() {
                      // Если уже выбрана эта зона, снимаем выбор, иначе выбираем новую
                      _selectedZone = isSelected ? null : zoneCode;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? accentColor.withValues(alpha: 0.1) : inputBg, // Исправлено withOpacity
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
              }), // Убран .toList() так как он не нужен в spread (...)
            ],

            const SizedBox(height: 24),

            // --- ИТОГО ---
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
    final linePaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.4) // Исправлено withOpacity
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final innerCirclePaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.4) // Исправлено withOpacity
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final outerCirclePaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.4) // Исправлено withOpacity
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

    canvas.drawCircle(Offset(centerX, centerY), 3, Paint()..color = Colors.black.withValues(alpha: 0.5)); // Исправлено withOpacity
    canvas.drawCircle(Offset(centerX, centerY - outerRadius), 4, Paint()..color = Colors.red.withValues(alpha: 0.5)); // Исправлено withOpacity
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}