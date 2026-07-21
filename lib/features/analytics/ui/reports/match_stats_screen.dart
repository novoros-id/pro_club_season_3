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

  // 🎨 Дизайн-система (Светлая тема, как в остальном приложении)
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
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Белый фон
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
                SizedBox(width: 60, child: _buildHeader('ДАТА')),
                Expanded(flex: 2, child: _buildHeader('СОПЕРНИК')),
                SizedBox(width: 50, child: _buildHeader('БР.', align: TextAlign.center)),
                SizedBox(width: 50, child: _buildHeader('ГОЛЫ', align: TextAlign.center)),
                SizedBox(width: 50, child: _buildHeader('%', align: TextAlign.center)),
                // ✅ Убрали колонку под крестик, теперь таблица занимает всю ширину
              ],
            ),
          ),

          // --- СПИСОК ИГР ---
          Expanded(
            child: ListView.builder(
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final match = _matches[index];

                // Парсим счет
                int ourScore = 0;
                int oppScore = 0;
                if (match.score != null && match.score!.contains(':')) {
                  final parts = match.score!.split(':');
                  ourScore = int.tryParse(parts[0]) ?? 0;
                  oppScore = int.tryParse(parts[1]) ?? 0;
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
                        width: 60,
                        child: Text(
                          DateFormat('dd.MM.yy').format(match.date),
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 14,
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

                      // БРОСКИ (Saves + Goals Conceded)
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

                      // ГОЛЫ (Пропущенные)
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

                      // % ОТРАЖЕНИЙ
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${match.savePercentage?.toStringAsFixed(0) ?? '-'}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            // Подсветка лаймом, если процент высокий (>90%)
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
        color: auxText, // Серый цвет для заголовков
        letterSpacing: 0.5,
      ),
    );
  }
}