import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';
import '../providers/analytics_filter_provider.dart';
import 'reports/match_stats_screen.dart';
import 'reports/goals_conceded_map_screen.dart';
import 'reports/shot_origin_map_screen.dart';
import 'reports/form_trend_screen.dart';
import 'reports/avg_ratings_screen.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  List<Goalkeeper> _goalkeepers = [];
  bool _isLoading = true;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color auxText = Color(0xFF9B9EA1);
  static const double borderRadius = 15.0;

  @override
  void initState() {
    super.initState();
    _loadGoalkeepers();
  }

  Future<void> _loadGoalkeepers() async {
    final db = ref.read(databaseProvider);
    final keepers = await db.getAllGoalkeepers();
    setState(() {
      _goalkeepers = keepers;
      _isLoading = false;
    });

    // Если есть вратари, но фильтр пуст, выбираем первого по умолчанию
    if (keepers.isNotEmpty && ref.read(analyticsFilterProvider).selectedGoalkeeper == null) {
      ref.read(analyticsFilterProvider.notifier).setGoalkeeper(keepers.first);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: ref.read(analyticsFilterProvider).startDate ?? DateTime.now().subtract(const Duration(days: 30)),
        end: ref.read(analyticsFilterProvider).endDate ?? DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(analyticsFilterProvider.notifier).setDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(analyticsFilterProvider);
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'АНАЛИТИКА',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 24,
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
            // --- БЛОК ФИЛЬТРОВ ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // Выбор вратаря
                  Row(
                    children: [
                      const Icon(Icons.person, color: primaryText, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Goalkeeper>(
                            isExpanded: true,
                            value: filters.selectedGoalkeeper,
                            hint: const Text('Выберите вратаря', style: TextStyle(fontFamily: 'Lato', color: auxText)),
                            style: const TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.bold, color: primaryText),
                            icon: const Icon(Icons.arrow_drop_down, color: accentColor),
                            items: _goalkeepers.map((keeper) {
                              return DropdownMenuItem<Goalkeeper>(
                                value: keeper,
                                child: Text('${keeper.firstName} ${keeper.lastName}', overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              ref.read(analyticsFilterProvider.notifier).setGoalkeeper(newValue);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 1, color: Colors.grey),
                  // Выбор периода
                  InkWell(
                    onTap: () => _selectDateRange(context),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: primaryText, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            filters.startDate != null && filters.endDate != null
                                ? '${dateFormat.format(filters.startDate!)} - ${dateFormat.format(filters.endDate!)}'
                                : 'Выберите период',
                            style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: primaryText),
                          ),
                        ),
                        const Icon(Icons.edit, color: auxText, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- МЕНЮ ОТЧЕТОВ ---
            const Text(
              'ОТЧЕТЫ',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _ReportCard(
                  title: 'Статистика\nпо матчам',
                  icon: Icons.bar_chart,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MatchStatsScreen(),
                      ),
                    );
                  },
                ),
                _ReportCard(
                  title: 'Пропущенные\nголы',
                  icon: Icons.sports_hockey,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GoalsConcededMapScreen(),
                      ),
                    );
                  },
                ),
                _ReportCard(
                  title: 'Откуда\nбили',
                  icon: Icons.my_location,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShotOriginMapScreen(),
                      ),
                    );
                  },
                ),
                _ReportCard(
                  title: 'Динамика\nформы',
                  icon: Icons.show_chart,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FormTrendScreen(),
                      ),
                    );
                  },
                ),
                _ReportCard(
                  title: 'Моё\nсостояние',
                  icon: Icons.favorite_outline, // Или Icons.psychology
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvgRatingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Виджет карточки отчета
class _ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFBBF246), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: const Color(0xFF121212)),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF121212),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}