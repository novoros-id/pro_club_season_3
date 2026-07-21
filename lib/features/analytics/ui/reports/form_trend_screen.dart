import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/app_database.dart';
import '../../providers/analytics_filter_provider.dart';

class FormTrendScreen extends ConsumerStatefulWidget {
  const FormTrendScreen({super.key});

  @override
  ConsumerState<FormTrendScreen> createState() => _FormTrendScreenState();
}

class _FormTrendScreenState extends ConsumerState<FormTrendScreen> {
  List<Matche> _matches = [];
  bool _isLoading = true;

  //  Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color inputBg = Color(0xFFF2F2F7);

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
        _matches = [];
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

    // 3. Сортируем по дате (от старых к новым для графика)
    filteredMatches.sort((a, b) => a.date.compareTo(b.date));

    setState(() {
      _matches = filteredMatches;
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
          'ДИНАМИКА ФОРМЫ',
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
          : _matches.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Нет данных за выбранный период.',
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
            // --- ГРАФИК % ОТРАЖЕНИЙ ---
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: LineChart(
                _mainChartData(),
              ),
            ),

            const SizedBox(height: 24),

            // --- ЛЕГЕНДА И ПОЯСНЕНИЯ ---
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '% Отражений',
                  style: TextStyle(fontFamily: 'Lato', fontSize: 14, color: primaryText),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- СПИСОК ИГР (Краткий) ---
            const Text(
              'ПОДРОБНОСТИ ПО ИГРАМ',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final match = _matches[index];
                final savePct = match.savePercentage ?? 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      // Дата
                      SizedBox(
                        width: 60,
                        child: Text(
                          DateFormat('dd.MM').format(match.date),
                          style: const TextStyle(fontFamily: 'Unbounded', fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Соперник
                      Expanded(
                        child: Text(
                          match.opponent,
                          style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: primaryText),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // % отражений
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${savePct.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Данные для графика FlChart
  LineChartData _mainChartData() {
    // Формируем точки для графика: X - индекс игры, Y - % отражений
    final spots = <FlSpot>[];
    for (int i = 0; i < _matches.length; i++) {
      final savePct = _matches[i].savePercentage ?? 0;
      spots.add(FlSpot(i.toDouble(), savePct));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 20,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= _matches.length) return const Text('');
              final date = _matches[value.toInt()].date;
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
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 10, color: Color(0xFF9B9EA1)),
              );
            },
            interval: 20,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (_matches.length > 1 ? _matches.length - 1 : 1).toDouble(),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: accentColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: accentColor,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: accentColor.withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black87,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x.toInt() >= _matches.length) return null;

              final match = _matches[flSpot.x.toInt()];
              final savePct = match.savePercentage ?? 0;

              return LineTooltipItem(
                '${DateFormat('dd.MM.yyyy').format(match.date)}\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Unbounded'),
                children: [
                  TextSpan(
                    text: 'vs ${match.opponent}\n',
                    style: const TextStyle(color: Colors.white70, fontFamily: 'Lato'),
                  ),
                  TextSpan(
                    text: 'Счёт: ${match.score ?? "-"}\n',
                    style: const TextStyle(color: Colors.white70, fontFamily: 'Lato'),
                  ),
                  TextSpan(
                    text: '% Отражений: ${savePct.toStringAsFixed(1)}%',
                    style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontFamily: 'Unbounded'),
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
}