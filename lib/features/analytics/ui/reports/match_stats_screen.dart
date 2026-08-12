import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/database/app_database.dart';
import '../../providers/analytics_filter_provider.dart';

class MatchStatsScreen extends ConsumerStatefulWidget {
  const MatchStatsScreen({super.key});

  @override
  ConsumerState<MatchStatsScreen> createState() => _MatchStatsScreenState();
}

class _MatchStatsScreenState extends ConsumerState<MatchStatsScreen> {
  List<Matche> _matches = [];
  bool _isLoading = true;

  //  Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color dividerColor = Color(0xFFEEEEEE);

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
    final allMatches = await db.getMatchesByGoalkeeper(filters.selectedGoalkeeper!.id);

    final filteredMatches = allMatches.where((m) {
      return m.date.isAfter(filters.startDate!.subtract(const Duration(days: 1))) &&
          m.date.isBefore(filters.endDate!.add(const Duration(days: 1)));
    }).toList();

    // Сортируем по дате (свежие сверху)
    filteredMatches.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _matches = filteredMatches;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Подсчет итогов
    int totalGames = _matches.length;
    int totalMinutes = 0;
    int totalShots = 0;
    int totalGoals = 0;
    double totalSavePct = 0;
    int countWithPct = 0;

    for (var match in _matches) {
      // Минуты
      if (match.gameDuration != null) {
        totalMinutes += match.gameDuration!;
      } else if (match.gameTime != null && match.gameTime!.contains(':')) {
        final parts = match.gameTime!.split(':');
        if (parts.length >= 2) {
          final h = int.tryParse(parts[0]) ?? 0;
          final m = int.tryParse(parts[1]) ?? 0;
          totalMinutes += (h * 60) + m;
        } else {
          totalMinutes += 60;
        }
      } else {
        totalMinutes += 60;
      }

      // Броски и Голы
      totalShots += (match.saves ?? 0) + (match.goalsConceded ?? 0);
      totalGoals += (match.goalsConceded ?? 0);

      // Средний процент
      if (match.savePercentage != null) {
        totalSavePct += match.savePercentage!;
        countWithPct++;
      }
    }

    final avgSavePct = countWithPct > 0 ? (totalSavePct / countWithPct).toStringAsFixed(1) : '-';

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
          'ИГРЫ',
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
          : Column(
        children: [
          // --- ЗАГОЛОВКИ ТАБЛИЦЫ ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
            ),
            child: Row(
              children: [
                SizedBox(width: 50, child: _buildHeader('ДАТА')),
                Expanded(flex: 2, child: _buildHeader('СОПЕРНИК')),
                SizedBox(width: 50, child: _buildHeader('ВРЕМЯ', align: TextAlign.center)),
                SizedBox(width: 50, child: _buildHeader('БР.', align: TextAlign.center)),
                SizedBox(width: 50, child: _buildHeader('ГОЛЫ', align: TextAlign.center)),
                SizedBox(width: 50, child: _buildHeader('%', align: TextAlign.center)),
              ],
            ),
          ),

          // --- СПИСОК ИГР ---
          Expanded(
            child: ListView.builder(
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final match = _matches[index];

                String timeStr = '-';
                if (match.gameTime != null) {
                  timeStr = match.gameTime!;
                } else if (match.gameDuration != null) {
                  timeStr = '${match.gameDuration}\' ';
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
                  ),
                  child: Row(
                    children: [
                      // ДАТА
                      SizedBox(
                        width: 50,
                        child: Text(
                          DateFormat('dd.MM').format(match.date),
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 12,
                            color: primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // СОПЕРНИК
                      Expanded(
                        flex: 2,
                        child: Text(
                          match.opponent.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 14,
                            color: primaryText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // ВРЕМЯ
                      SizedBox(
                        width: 50,
                        child: Text(
                          timeStr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            color: auxText,
                          ),
                        ),
                      ),

                      // БРОСКИ
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${(match.saves ?? 0) + (match.goalsConceded ?? 0)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            color: primaryText,
                          ),
                        ),
                      ),

                      // ГОЛЫ
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${match.goalsConceded ?? 0}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            color: primaryText,
                          ),
                        ),
                      ),

                      // % ОТРАЖЕНИЙ (✅ ИЗМЕНЕНО НА toStringAsFixed(1))
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${match.savePercentage?.toStringAsFixed(1) ?? '-'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: match.savePercentage != null && match.savePercentage! > 90
                                ? accentColor
                                : primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // --- БЛОК ИТОГО ---
          Container(
            padding: const EdgeInsets.all(16),
            color: inputBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ИТОГО ЗА ПЕРИОД',
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Игр:', '$totalGames'),
                    _buildSummaryItem('Минут:', '$totalMinutes'),
                    _buildSummaryItem('Бросков:', '$totalShots'),
                    _buildSummaryItem('Голов:', '$totalGoals'),
                    _buildSummaryItem('Ср. %:', '$avgSavePct%'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: auxText,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 12,
            color: auxText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
      ],
    );
  }
}