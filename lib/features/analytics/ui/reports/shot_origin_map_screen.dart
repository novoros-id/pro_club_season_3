import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Для загрузки assets
import 'dart:convert'; // Для декодирования JSON
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

  // Режим отображения: 'stats' (по типам) или 'advice' (по зонам)
  String _viewMode = 'stats';

  // Выбранное значение для фильтрации (ID типа или Код зоны)
  dynamic _selectedFilter;

  // Данные легенды площадки, загружаемые из JSON
  List<Map<String, dynamic>> _rinkData = [];

  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color inputBg = Color(0xFFF2F2F7);

  // Пропорции картинки поля (как в GoalInputWizard)
  static const double aspectRatio = 1097 / 1055;

  // Цвета для типов бросков
  static const Map<int, Color> shotColors = {
    1: Colors.red,       // 🔴 Прямой бросок
    2: Colors.green,     // 🟢 Бросок с передачи
    3: Colors.blue,      // 🔵 Добивание
    4: Colors.orange,    // 🟠 Закрывание обзора
    5: Colors.grey,      // Подставление
    6: Colors.grey,      // Буллит
    7: Colors.yellow, // 🟡 Атака из-за ворот
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
    _loadRinkComments(); // Загружаем легенду площадки
    _loadData();         // Загружаем статистику
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Если нужно перезагружать данные при смене фильтров, можно добавить логику здесь
  }

  // Метод загрузки комментариев из JSON (shot_sources.json)
  Future<void> _loadRinkComments() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/shot_sources.json');
      final List<dynamic> data = json.decode(jsonString);

      if (mounted) {
        setState(() {
          _rinkData = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint("Ошибка загрузки легенды площадки: $e");
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
      _selectedFilter = null; // Сброс фильтра при перезагрузке
    });
  }

  // Статистика по типам бросков
  Map<int, int> _getTypeStats() {
    Map<int, int> stats = {};
    for (int i = 1; i <= 7; i++) stats[i] = 0;
    for (var goal in _allGoals) {
      if (stats.containsKey(goal.goalTypeId)) {
        stats[goal.goalTypeId] = stats[goal.goalTypeId]! + 1;
      }
    }
    var sortedEntries = stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries);
  }

  // Статистика по зонам площадки (fromZone)
  Map<String, int> _getRinkZoneStats() {
    Map<String, int> stats = {};
    for (var goal in _allGoals) {
      if (goal.fromZone != null && goal.fromZone!.isNotEmpty) {
        stats[goal.fromZone!] = (stats[goal.fromZone!] ?? 0) + 1;
      }
    }
    var sortedEntries = stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries);
  }

  // Получение комментария из загруженного JSON
  String _getRinkComment(String zoneCode) {
    if (_rinkData.isEmpty) return 'Загрузка...';

    // Ищем объект в списке, где поле 'код' совпадает с zoneCode
    final item = _rinkData.firstWhere(
          (element) => element['код'] == zoneCode,
      orElse: () => {},
    );

    if (item.isNotEmpty) {
      return item['текст_для_вратаря'] ?? 'Нет описания';
    }

    return 'Нет данных для этой зоны';
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width - 32;
    final double containerHeight = containerWidth * aspectRatio;

    final typeStats = _getTypeStats();
    final rinkStats = _getRinkZoneStats();
    final totalGoals = _allGoals.length;

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
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ПЕРЕКЛЮЧАТЕЛЬ РЕЖИМОВ ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _viewMode = 'stats';
                        _selectedFilter = null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _viewMode == 'stats' ? accentColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'СТАТИСТИКА',
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _viewMode == 'stats' ? primaryText : auxText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _viewMode = 'advice';
                        _selectedFilter = null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _viewMode == 'advice' ? accentColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'РЕКОМЕНДАЦИИ',
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _viewMode == 'advice' ? primaryText : auxText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- КАРТА ПОЛЯ ---
            Center(
              child: Stack(
                children: [
                  Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/pole_zones.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),

                  // Точки бросков с логикой подсветки
                  ..._allGoals.map((goal) {
                    if (goal.fromZoneX == null || goal.fromZoneY == null) return const SizedBox.shrink();

                    // Определяем, должна ли точка быть видимой и подсвеченной
                    bool isSelected = false;
                    bool isDimmed = false;

                    if (_selectedFilter != null) {
                      if (_viewMode == 'stats') {
                        // Фильтр по типу
                        if (goal.goalTypeId == _selectedFilter) {
                          isSelected = true;
                        } else {
                          isDimmed = true;
                        }
                      } else {
                        // Фильтр по зоне
                        if (goal.fromZone == _selectedFilter) {
                          isSelected = true;
                        } else {
                          isDimmed = true;
                        }
                      }
                    }

                    // Если точка затемнена, рисуем её маленькой и серой
                    if (isDimmed) {
                      return Positioned(
                        left: goal.fromZoneX! * containerWidth - 6,
                        top: goal.fromZoneY! * containerHeight - 6,
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

                    // Иначе рисуем обычную или выбранную точку
                    return Positioned(
                      left: goal.fromZoneX! * containerWidth - 8,
                      top: goal.fromZoneY! * containerHeight - 8,
                      child: GestureDetector(
                        onTap: () => _showGoalDetails(goal),
                        child: Container(
                          width: isSelected ? 20 : 16,
                          height: isSelected ? 20 : 16,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : (shotColors[goal.goalTypeId] ?? Colors.grey),
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

            // --- ТАБЛИЦА (Динамическая в зависимости от режима) ---
            if (_viewMode == 'stats') ...[
              _buildStatsTable(typeStats),
            ] else ...[
              _buildAdviceTable(rinkStats),
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
                    'ВСЕГО БРОСКОВ:',
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

  // Виджет таблицы статистики по типам
  Widget _buildStatsTable(Map<int, int> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'СТАТИСТИКА БРОСКОВ',
          style: TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.bold, color: primaryText),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: stats.entries.map((entry) {
              final typeId = entry.key;
              final count = entry.value;
              final isSelected = _selectedFilter == typeId;

              return InkWell(
                onTap: () => setState(() => _selectedFilter = isSelected ? null : typeId),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    color: isSelected ? accentColor.withValues(alpha: 0.1) : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: shotColors[typeId], shape: BoxShape.circle)),
                          const SizedBox(width: 10),
                          Text(goalTypeNames[typeId]!, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: primaryText)),
                        ],
                      ),
                      Text('$count', style: const TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.bold, color: primaryText)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Виджет таблицы рекомендаций по зонам
  Widget _buildAdviceTable(Map<String, int> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'РЕКОМЕНДАЦИИ ПО ЗОНАМ',
          style: TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.bold, color: primaryText),
        ),
        const SizedBox(height: 12),

        // Заголовки
        Row(
          children: [
            Expanded(flex: 1, child: Text('ЗОНА', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText))),
            Expanded(flex: 1, child: Text('ГОЛЫ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText), textAlign: TextAlign.center)),
            Expanded(flex: 3, child: Text('РЕКОМЕНДАЦИЯ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 12, color: auxText))),
          ],
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: stats.entries.map((entry) {
              final zoneCode = entry.key;
              final count = entry.value;
              // ✅ Берем комментарий из загруженного JSON
              final comment = _getRinkComment(zoneCode);
              final isSelected = _selectedFilter == zoneCode;

              return InkWell(
                onTap: () => setState(() => _selectedFilter = isSelected ? null : zoneCode),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? accentColor : Colors.transparent, width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: Text(zoneCode, style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? accentColor : primaryText))),
                      Expanded(flex: 1, child: Text('$count', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? accentColor : primaryText))),
                      Expanded(flex: 3, child: Text(comment, style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: primaryText, height: 1.3))),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showGoalDetails(Goal goal) {
    final match = _matchesMap[goal.matchId];
    if (match == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('ДЕТАЛИ БРОСКА', style: const TextStyle(fontFamily: 'Unbounded', fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Тип:', goalTypeNames[goal.goalTypeId] ?? 'Неизвестно'),
            _detailRow('Зона:', goal.fromZone ?? '-'),
            _detailRow('Дата:', DateFormat('dd.MM.yyyy').format(match.date)),
            _detailRow('Соперник:', match.opponent),
            _detailRow('Счёт:', match.score ?? '-'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ЗАКРЫТЬ', style: TextStyle(color: accentColor))),
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
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato'))),
          Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Lato'))),
        ],
      ),
    );
  }
}