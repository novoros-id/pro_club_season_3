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

  // Утверждённая дизайн-система приложения.
  static const Color primaryText = Color(0xFF121A1F);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color borderGrey = Color(0xFFD8DADF);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color darkButton = Color(0xFF121A1F);
  static const Color softLime = Color(0x26BBF246);
  static const double borderRadius = 15;

  static const Color popupMenuBg = Color(0xFFF2F2F7);
  static const double popupMenuRadius = 15;
  static const double popupMenuItemHeight = 52;

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

    // Если есть вратари, но фильтр пуст, выбираем первого по умолчанию.
    if (keepers.isNotEmpty &&
        ref.read(analyticsFilterProvider).selectedGoalkeeper == null) {
      ref
          .read(analyticsFilterProvider.notifier)
          .setGoalkeeper(keepers.first);
    }
  }

  ThemeData _screenTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: accentColor,
        onPrimary: primaryText,
        primaryContainer: accentColor,
        onPrimaryContainer: primaryText,
        secondary: accentColor,
        onSecondary: primaryText,
        secondaryContainer: accentColor,
        onSecondaryContainer: primaryText,
        surface: Colors.white,
        onSurface: primaryText,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryText,
        selectionColor: Color(0x55BBF246),
        selectionHandleColor: accentColor,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
      ),
    );
  }

  ButtonStyle _calendarCancelButtonStyle() {
    return const ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(Size(0, 38)),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll<Color>(auxText),
      overlayColor: WidgetStatePropertyAll<Color>(Color(0x0D121A1F)),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  ButtonStyle _calendarConfirmButtonStyle() {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(Size(0, 38)),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder()),
      elevation: const WidgetStatePropertyAll<double>(0),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFFE3E4E8);
        }
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.focused)) {
          return accentColor;
        }
        return darkButton;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return auxText;
        }
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.focused)) {
          return primaryText;
        }
        return Colors.white;
      }),
      textStyle: const WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  DatePickerThemeData _calendarTheme() {
    return DatePickerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      headerBackgroundColor: Colors.white,
      headerForegroundColor: primaryText,
      headerHeadlineStyle: const TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 18,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headerHelpStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        color: auxText,
      ),
      weekdayStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        color: auxText,
      ),
      dayStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 14,
        color: primaryText,
      ),
      dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return auxText;
        }
        // Все цифры, включая начало и конец периода, остаются чёрными.
        return primaryText;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return accentColor;
        }
        return null;
      }),
      dayOverlayColor: const WidgetStatePropertyAll<Color>(softLime),
      todayForegroundColor:
      const WidgetStatePropertyAll<Color>(primaryText),
      todayBackgroundColor:
      const WidgetStatePropertyAll<Color>(softLime),
      todayBorder: BorderSide.none,
      rangePickerBackgroundColor: Colors.white,
      rangePickerSurfaceTintColor: Colors.transparent,
      rangePickerHeaderBackgroundColor: Colors.white,
      rangePickerHeaderForegroundColor: primaryText,
      subHeaderForegroundColor: primaryText,
      rangePickerHeaderHeadlineStyle: const TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 18,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      rangePickerHeaderHelpStyle: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        color: auxText,
      ),
      rangeSelectionBackgroundColor: softLime,
      rangeSelectionOverlayColor:
      const WidgetStatePropertyAll<Color>(softLime),
      dividerColor: borderGrey,
      cancelButtonStyle: _calendarCancelButtonStyle(),
      confirmButtonStyle: _calendarConfirmButtonStyle(),
      inputDecorationTheme: InputDecorationThemeData(
        isDense: true,
        filled: true,
        fillColor: inputBg,
        constraints: const BoxConstraints(minHeight: 56),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: auxText,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          color: primaryText,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 16,
          color: auxText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: borderGrey, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: borderGrey, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: ref.read(analyticsFilterProvider).startDate ??
            DateTime.now().subtract(const Duration(days: 30)),
        end:
        ref.read(analyticsFilterProvider).endDate ?? DateTime.now(),
      ),
      locale: const Locale('ru', 'RU'),
      helpText: 'ВЫБЕРИТЕ ПЕРИОД',
      cancelText: 'Отмена',
      confirmText: 'Применить',
      saveText: 'Применить',
      fieldStartLabelText: 'Дата начала',
      fieldEndLabelText: 'Дата окончания',
      fieldStartHintText: 'дд.мм.гггг',
      fieldEndHintText: 'дд.мм.гггг',
      errorFormatText: 'Введите дату в формате дд.мм.гггг',
      errorInvalidText: 'Дата вне доступного диапазона',
      errorInvalidRangeText: 'Дата окончания раньше начала',
      builder: (context, child) {
        final calendarTheme = _screenTheme(context);
        final calendarTextTheme = calendarTheme.textTheme
            .apply(
          fontFamily: 'Lato',
          bodyColor: primaryText,
          displayColor: primaryText,
        )
            .copyWith(
          headlineSmall: const TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
          labelLarge: const TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        );
        return Theme(
          data: calendarTheme.copyWith(
            colorScheme: calendarTheme.colorScheme.copyWith(
              primary: accentColor,
              onPrimary: primaryText,
              primaryContainer: accentColor,
              onPrimaryContainer: primaryText,
              secondary: accentColor,
              onSecondary: primaryText,
              secondaryContainer: accentColor,
              onSecondaryContainer: primaryText,
            ),
            datePickerTheme: _calendarTheme(),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
            // Flutter берёт цвет цифр внутри диапазона из bodyMedium,
            // поэтому всю типографику календаря делаем чёрной.
            textTheme: calendarTextTheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref
          .read(analyticsFilterProvider.notifier)
          .setDateRange(picked.start, picked.end);
    }
  }

  Widget _buildGoalkeeperField(Goalkeeper? selectedGoalkeeper) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: softLime,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0x66BBF246),
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: primaryText,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _goalkeepers.isEmpty
                ? const Text(
              'Нет вратарей',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 16,
                color: auxText,
              ),
            )
                : PopupMenuButton<Goalkeeper>(
              tooltip: 'Выбрать вратаря',
              initialValue: selectedGoalkeeper,
              position: PopupMenuPosition.under,
              offset: const Offset(0, 12),
              color: popupMenuBg,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.black12,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(popupMenuRadius),
              ),
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.of(context).size.width - 32)
                    .clamp(0.0, 320.0)
                    .toDouble(),
              ),
              onSelected: (Goalkeeper newValue) {
                ref
                    .read(analyticsFilterProvider.notifier)
                    .setGoalkeeper(newValue);
              },
              itemBuilder: (context) {
                return _goalkeepers.map((keeper) {
                  final bool isSelected =
                      keeper.id == selectedGoalkeeper?.id;

                  return PopupMenuItem<Goalkeeper>(
                    value: keeper,
                    height: popupMenuItemHeight,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: isSelected ? primaryText : auxText,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${keeper.firstName} ${keeper.lastName}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: primaryText,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: primaryText,
                            size: 18,
                          ),
                      ],
                    ),
                  );
                }).toList();
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedGoalkeeper == null
                            ? 'Выберите вратаря'
                            : '${selectedGoalkeeper.firstName} '
                            '${selectedGoalkeeper.lastName}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: 16,
                          fontWeight: selectedGoalkeeper == null
                              ? FontWeight.w500
                              : FontWeight.bold,
                          color: selectedGoalkeeper == null
                              ? auxText
                              : primaryText,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: primaryText,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodField({
    required String label,
    required bool hasSelection,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: () => _selectDateRange(context),
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: softLime,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: hasSelection ? Colors.white : inputBg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: hasSelection ? accentColor : borderGrey,
              width: hasSelection ? 1.6 : 1.2,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: primaryText,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight:
                    hasSelection ? FontWeight.w700 : FontWeight.w400,
                    color: hasSelection ? primaryText : auxText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.edit_outlined,
                color: primaryText,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsGrid() {
    final reports = <Widget>[
      _ReportCard(
        title: 'Статистика по матчам',
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
        title: 'Пропущенные голы',
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
        title: 'Откуда били',
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
        title: 'Динамика формы',
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
        title: 'Моё состояние',
        icon: Icons.favorite_outline,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AvgRatingsScreen(),
            ),
          );
        },
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 620
            ? 3
            : constraints.maxWidth < 300
            ? 1
            : 2;
        const horizontalSpacing = 14.0;
        const verticalSpacing = 18.0;
        final itemWidth =
            (constraints.maxWidth - horizontalSpacing * (columns - 1)) /
                columns;
        final itemHeight = columns == 1
            ? 126.0
            : itemWidth < 170
            ? 164.0
            : 154.0;

        return Wrap(
          alignment: WrapAlignment.start,
          spacing: horizontalSpacing,
          runSpacing: verticalSpacing,
          children: reports
              .map(
                (report) => SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: report,
              ),
            ),
          )
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(analyticsFilterProvider);
    final dateFormat = DateFormat('dd.MM.yyyy');
    final hasPeriod = filters.startDate != null && filters.endDate != null;
    final periodLabel = hasPeriod
        ? '${dateFormat.format(filters.startDate!)} — '
        '${dateFormat.format(filters.endDate!)}'
        : 'Выберите период';
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Theme(
      data: _screenTheme(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Назад',
            icon: const Icon(Icons.arrow_back, color: primaryText),
            onPressed: () => context.pop(),
          ),
          titleSpacing: 0,
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'АНАЛИТИКА',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: primaryText,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildGoalkeeperField(
                      filters.selectedGoalkeeper,
                    ),
                    const SizedBox(height: 12),
                    _buildPeriodField(
                      label: periodLabel,
                      hasSelection: hasPeriod,
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'ОТЧЁТЫ',
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReportsGrid(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  static const Color primaryText = Color(0xFF121A1F);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color borderGrey = Color(0xFFD8DADF);
  static const Color softLime = Color(0x26BBF246);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // Граница рисуется поверх InkWell, поэтому не пропадает
        // на дробных координатах и во время отклика на нажатие.
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderGrey, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.transparent,
            highlightColor: accentColor,
            overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.pressed)) {
                return accentColor;
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.hovered)) {
                return softLime;
              }
              return null;
            }),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: softLime,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: accentColor.withOpacity(0.45),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, size: 25, color: primaryText),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 13,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
