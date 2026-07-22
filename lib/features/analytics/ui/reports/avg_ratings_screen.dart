import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/app_database.dart';
import '../../providers/analytics_filter_provider.dart';

class AvgRatingsScreen extends ConsumerStatefulWidget {
  const AvgRatingsScreen({super.key});

  @override
  ConsumerState<AvgRatingsScreen> createState() => _AvgRatingsScreenState();
}

class _AvgRatingsScreenState extends ConsumerState<AvgRatingsScreen> {
  Map<String, double> _averages = {};
  List<Matche> _matchesForChart = []; // Данные для графика
  bool _isLoading = true;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color inputBg = Color(0xFFF2F2F7);

  // Цвета для линий графика
  static const Map<String, Color> lineColors = {
    'mood': Color(0xFFBBF246),      // Лайм (Настрой)
    'warmup': Color(0xFF1E88E5),    // Синий (Разминка)
    'conf': Color(0xFF8E24AA),      // Фиолетовый (Уверенность)
    'saves': Color(0xFFFF6F00),     // Оранжевый (Спасения)
  };

  final List<Map<String, String>> _ratingLabels = [
    {'key': 'mood', 'label': 'Настрой на игру'},
    {'key': 'warmup', 'label': 'Разминка'},
    {'key': 'conf', 'label': 'Уверенность'},
    {'key': 'saves', 'label': 'Хорошие спасения'},
  ];

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
        _averages = {};
        _matchesForChart = [];
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

    // Сортируем по дате для графика
    filteredMatches.sort((a, b) => a.date.compareTo(b.date));

    if (filteredMatches.isEmpty) {
      setState(() {
        _averages = {};
        _matchesForChart = [];
        _isLoading = false;
      });
      return;
    }

    // Считаем средние значения
    double sumMood = 0, sumWarmup = 0, sumConf = 0, sumSaves = 0;
    int countMood = 0, countWarmup = 0, countConf = 0, countSaves = 0;

    for (var match in filteredMatches) {
      if (match.moodRating != null) { sumMood += match.moodRating!; countMood++; }
      if (match.warmupRating != null) { sumWarmup += match.warmupRating!; countWarmup++; }
      if (match.confidenceRating != null) { sumConf += match.confidenceRating!; countConf++; }
      if (match.greatSavesRating != null) { sumSaves += match.greatSavesRating!; countSaves++; }
    }

    setState(() {
      _matchesForChart = filteredMatches;
      _averages = {
        'mood': countMood > 0 ? sumMood / countMood : 0,
        'warmup': countWarmup > 0 ? sumWarmup / countWarmup : 0,
        'conf': countConf > 0 ? sumConf / countConf : 0,
        'saves': countSaves > 0 ? sumSaves / countSaves : 0,
      };
      _isLoading = false;
    });
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
        title: const Text(
          'МОЁ СОСТОЯНИЕ',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentColor))
          : _averages.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Нет данных об оценках\nза выбранный период.',
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
            // --- ГРАФИК ДИНАМИКИ ---
            const Text(
              'ДИНАМИКА ПО ИГРАМ',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              height: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: LineChart(
                _mainChartData(),
              ),
            ),

            const SizedBox(height: 16),

            // --- ЛЕГЕНДА ---
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: _ratingLabels.map((item) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: lineColors[item['key']],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item['label']!,
                      style: const TextStyle(fontSize: 12, fontFamily: 'Lato', color: primaryText),
                    ),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // --- СРЕДНИЕ ЗНАЧЕНИЯ (БАРЫ) ---
            const Text(
              'СРЕДНИЕ ОЦЕНКИ',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 12),

            ..._ratingLabels.map((item) {
              final value = _averages[item['key']] ?? 0;
              return _RatingBar(
                label: item['label']!,
                value: value,
                color: lineColors[item['key']]!,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Данные для графика FlChart
  LineChartData _mainChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1, // Шаг по Y (оценки 1-5)
        verticalInterval: 1,   // Шаг по X (игры)
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= _matchesForChart.length) return const Text('');
              final date = _matchesForChart[value.toInt()].date;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat('dd.MM').format(date),
                  style: const TextStyle(fontSize: 10, color: Color(0xFF9B9EA1)),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF9B9EA1)),
              );
            },
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (_matchesForChart.length > 1 ? _matchesForChart.length - 1 : 1).toDouble(),
      minY: 0,
      maxY: 5.5, // Чуть выше 5, чтобы точки не прилипали к верху
      lineBarsData: [
        // Линия Настроя
        _createLineData('mood'),
        // Линия Разминки
        _createLineData('warmup'),
        // Линия Уверенности
        _createLineData('conf'),
        // Линия Спасений
        _createLineData('saves'),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black87,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x.toInt() >= _matchesForChart.length) return null;

              final match = _matchesForChart[flSpot.x.toInt()];
              final color = barSpot.bar.color;

              // Определяем, какой это параметр по цвету (упрощенно)
              String paramName = '';
              if (color == lineColors['mood']) paramName = 'Настрой';
              else if (color == lineColors['warmup']) paramName = 'Разминка';
              else if (color == lineColors['conf']) paramName = 'Уверенность';
              else if (color == lineColors['saves']) paramName = 'Спасения';

              return LineTooltipItem(
                '${DateFormat('dd.MM').format(match.date)}\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Unbounded', fontSize: 12),
                children: [
                  TextSpan(
                    text: '$paramName: ',
                    style: const TextStyle(color: Colors.white70, fontFamily: 'Lato'),
                  ),
                  TextSpan(
                    text: flSpot.y.toStringAsFixed(1),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontFamily: 'Unbounded'),
                  ),
                ],
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }

  LineChartBarData _createLineData(String key) {
    final spots = <FlSpot>[];
    for (int i = 0; i < _matchesForChart.length; i++) {
      final match = _matchesForChart[i];
      double? val;
      if (key == 'mood') val = match.moodRating?.toDouble();
      else if (key == 'warmup') val = match.warmupRating?.toDouble();
      else if (key == 'conf') val = match.confidenceRating?.toDouble();
      else if (key == 'saves') val = match.greatSavesRating?.toDouble();

      if (val != null) {
        spots.add(FlSpot(i.toDouble(), val));
      }
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: lineColors[key]!,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false), // Точки скрываем, чтобы не засорять график, если игр много
      belowBarData: BarAreaData(show: false),
    );
  }
}

// Виджет одной строки с гистограммой (обновлен с динамическим цветом)
class _RatingBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _RatingBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF121212),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value / 5,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: color, // Используем цвет из легенды
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 30,
            child: Text(
              value.toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF121212),
              ),
            ),
          ),
        ],
      ),
    );
  }
}