import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';
import 'goal_list_screen.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class DiaryMainScreen extends ConsumerStatefulWidget {
  const DiaryMainScreen({super.key});

  @override
  ConsumerState<DiaryMainScreen> createState() => _DiaryMainScreenState();
}

class _DiaryMainScreenState extends ConsumerState<DiaryMainScreen> {
  DateTimeRange? _selectedDateRange;
  List<Goalkeeper> _goalkeepers = [];
  Goalkeeper? _selectedGoalkeeper;
  List<Matche> _matches = [];
  bool _isLoading = true;
  bool _showAllMatches = true;
  bool _isAddButtonPressed = false;
  int? _pressedGoalsMatchId;

  // Состояние собственного выбора периода
  bool _isPeriodPickerOpen = false;
  bool _showManualPeriodInput = false;
  DateTime? _periodStartDate;
  DateTime? _periodEndDate;
  DateTime _periodVisibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  final TextEditingController _periodStartController =
  TextEditingController();
  final TextEditingController _periodEndController =
  TextEditingController();

  String? _periodStartError;
  String? _periodEndError;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121A1F);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color borderGrey = Color(0xFFD8DADF);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color darkButton = Color(0xFF121A1F);
  static const Color softLime = Color(0x26BBF246);
  static const double borderRadius = 15.0;

  // Единый стиль всплывающих меню
  static const Color popupMenuBg = Color(0xFFF2F2F7);
  static const double popupMenuRadius = 15.0;
  static const double popupMenuItemHeight = 52.0;

  ThemeData _diaryTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: accentColor,
        onPrimary: primaryText,
        secondary: accentColor,
        onSecondary: primaryText,
        surface: Colors.white,
        onSurface: primaryText,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryText,
        selectionColor: Color(0x55BBF246),
        selectionHandleColor: accentColor,
      ),
      sliderTheme: SliderTheme.of(context).copyWith(
        activeTrackColor: accentColor,
        inactiveTrackColor: borderGrey,
        thumbColor: accentColor,
        overlayColor: softLime,
        valueIndicatorColor: darkButton,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Unbounded',
          color: Colors.white,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
      ),
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(64)),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        StadiumBorder(),
      ),
      elevation: const WidgetStatePropertyAll<double>(0),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return const Color(0xFFE3E4E8);
        }

        if (states.contains(WidgetState.pressed)) {
          return accentColor;
        }

        return darkButton;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return auxText;
        }

        if (states.contains(WidgetState.pressed)) {
          return primaryText;
        }

        return Colors.white;
      }),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      textStyle: const WidgetStatePropertyAll<TextStyle>(
        TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _periodStartController.dispose();
    _periodEndController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);

    // 1. Загружаем вратарей
    final keepers = await db.getAllGoalkeepers();

    // 2. Выбираем текущего вратаря
    Goalkeeper? currentKeeper = keepers.where((k) => k.isCurrent).toList().firstOrNull;
    if (currentKeeper == null && keepers.isNotEmpty) {
      currentKeeper = keepers.first;
    }

    setState(() {
      _goalkeepers = keepers;
      _selectedGoalkeeper = currentKeeper;
    });

    // 3. Загружаем игры
    await _loadMatchesForDate();
  }

  // ✅ ОБНОВЛЕННЫЙ МЕТОД ЗАГРУЗКИ ИГР
  Future<void> _loadMatchesForDate() async {
    if (_selectedGoalkeeper == null) {
      setState(() {
        _matches = [];
        _isLoading = false;
      });
      return;
    }

    setState(() { _isLoading = true; });

    final db = ref.read(databaseProvider);
    List<Matche> matches = [];

    try {
      if (_showAllMatches || _selectedDateRange == null) {
        // Режим по умолчанию — все игры выбранного вратаря
        matches = await db.getMatchesByGoalkeeper(_selectedGoalkeeper!.id);
      } else {
        final allMatches =
        await db.getMatchesByGoalkeeper(_selectedGoalkeeper!.id);
        final rangeStart = DateTime(
          _selectedDateRange!.start.year,
          _selectedDateRange!.start.month,
          _selectedDateRange!.start.day,
        );
        final rangeEndExclusive = DateTime(
          _selectedDateRange!.end.year,
          _selectedDateRange!.end.month,
          _selectedDateRange!.end.day + 1,
        );

        matches = allMatches.where((match) {
          return !match.date.isBefore(rangeStart) &&
              match.date.isBefore(rangeEndExclusive);
        }).toList();
      }
    } catch (e) {
      print('Ошибка загрузки игр: $e');
    }

    setState(() {
      _matches = matches;
      _isLoading = false;
    });
  }

  // Выбор одной даты игры не изменяет фильтр периода или данные до сохранения формы.
  Future<DateTime?> _pickMatchDate(
      BuildContext context,
      DateTime currentDate,
      ) async {
    FocusScope.of(context).unfocus();
    final initialDay = DateTime(
      currentDate.year, currentDate.month, currentDate.day,
    );
    final firstDay = DateTime(2020);
    final lastDay = DateTime(2100, 12, 31);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDay,
      // Старую запись можно открыть даже за пределами обычного диапазона.
      firstDate: initialDay.isBefore(firstDay) ? initialDay : firstDay,
      lastDate: initialDay.isAfter(lastDay) ? initialDay : lastDay,
      locale: const Locale('ru', 'RU'),
      helpText: 'ДАТА ИГРЫ',
      cancelText: 'Отмена',
      confirmText: 'ОК',
      fieldLabelText: 'Дата игры',
      fieldHintText: 'дд.мм.гггг',
      errorFormatText: 'Введите дату в формате дд.мм.гггг',
      errorInvalidText: 'Дата вне доступного диапазона',
      builder: (context, child) {
        return Theme(
          data: _diaryTheme(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: accentColor,
              onPrimary: primaryText,
              surface: Colors.white,
              onSurface: primaryText,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              headerForegroundColor: primaryText,
              todayForegroundColor:
              const WidgetStatePropertyAll<Color>(primaryText),
              todayBackgroundColor:
              const WidgetStatePropertyAll<Color>(
                Color(0x33BBF246),
              ),
              todayBorder: BorderSide.none,
              headerHeadlineStyle: const TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
              cancelButtonStyle: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll<Size>(
                  Size(0, 38),
                ),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Colors.transparent,
                ),
                foregroundColor: WidgetStatePropertyAll<Color>(
                  auxText,
                ),
                overlayColor: WidgetStatePropertyAll<Color>(
                  Color(0x0D121A1F),
                ),
                textStyle: WidgetStatePropertyAll<TextStyle>(
                  TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              confirmButtonStyle: ButtonStyle(
                minimumSize: const WidgetStatePropertyAll<Size>(
                  Size(0, 38),
                ),
                padding:
                const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                shape:
                const WidgetStatePropertyAll<OutlinedBorder>(
                  StadiumBorder(),
                ),
                elevation: const WidgetStatePropertyAll<double>(0),
                overlayColor:
                const WidgetStatePropertyAll<Color>(
                  accentColor,
                ),
                textStyle:
                const WidgetStatePropertyAll<TextStyle>(
                  TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor:
                WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xFFE3E4E8);
                    }

                    if (states.contains(WidgetState.pressed) ||
                        states.contains(WidgetState.focused)) {
                      return accentColor;
                    }

                    return primaryText;
                  },
                ),
                foregroundColor:
                WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return auxText;
                    }

                    if (states.contains(WidgetState.pressed) ||
                        states.contains(WidgetState.focused)) {
                      return primaryText;
                    }

                    return Colors.white;
                  },
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationThemeData(
              isDense: true,
              filled: true,
              fillColor: inputBg,
              constraints: const BoxConstraints(
                minHeight: 56,
              ),
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
                color: auxText,
              ),
              hintStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                color: auxText,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: borderGrey,
                  width: 1.4,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: borderGrey,
                  width: 1.4,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: accentColor,
                  width: 2,
                ),
              ),
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
              bodyLarge: TextStyle(
                fontFamily: 'Lato',
                color: primaryText,
              ),
              labelLarge: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return null;
    if (picked.year == currentDate.year &&
        picked.month == currentDate.month &&
        picked.day == currentDate.day) {
      return currentDate;
    }

    // Меняем только календарный день; время и UTC/local исходной записи сохраняем.
    if (currentDate.isUtc) {
      return DateTime.utc(
        picked.year, picked.month, picked.day,
        currentDate.hour, currentDate.minute, currentDate.second,
        currentDate.millisecond, currentDate.microsecond,
      );
    }
    return DateTime(
      picked.year, picked.month, picked.day,
      currentDate.hour, currentDate.minute, currentDate.second,
      currentDate.millisecond, currentDate.microsecond,
    );
  }

  Widget _buildMatchDateField({
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: softLime,
        highlightColor: Colors.transparent,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Дата игры',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(
              fontFamily: 'Lato', fontSize: 14, color: auxText,
            ),
            floatingLabelStyle: const TextStyle(
              fontFamily: 'Lato', fontSize: 14, color: primaryText,
            ),
            filled: true,
            fillColor: inputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16,
            ),
            prefixIcon: const Icon(
              Icons.calendar_today_outlined, color: primaryText,
            ),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down, color: primaryText,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: accentColor, width: 1.4),
            ),
          ),
          child: Text(
            DateFormat('dd.MM.yyyy').format(date),
            softWrap: true,
            style: const TextStyle(
              fontFamily: 'Lato', fontSize: 16, color: primaryText,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddMatchDialog() async {
    if (_selectedGoalkeeper == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала выберите вратаря')),
      );
      return;
    }
    DateTime matchDate = DateTime.now();
    final opponentController = TextEditingController();
    final teamScoreController = TextEditingController();
    final opponentScoreController = TextEditingController();
    final gameTimeController = TextEditingController();
    final personalTasksController = TextEditingController();
    final goalsConcededController = TextEditingController();
    final savesController = TextEditingController();
    final commentsController = TextEditingController();
    int moodRating = 3;
    int warmupRating = 3;
    int confidenceRating = 3;
    int greatSavesRating = 3;
    bool showAdvanced = false;
    String? opponentError;
    String? teamScoreError;
    String? opponentScoreError;
    String? gameTimeError;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Theme(
        data: _diaryTheme(sheetContext),
        child: StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'ДОБАВИТЬ ИГРУ',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Обязательные поля отмечены *',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13,
                      color: auxText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMatchDateField(
                    date: matchDate,
                    onTap: () async {
                      final picked = await _pickMatchDate(context, matchDate);
                      if (!context.mounted || picked == null) return;
                      setModalState(() => matchDate = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    opponentController,
                    'Соперник *',
                    Icons.sports_hockey,
                    errorText: opponentError,
                    onChanged: (_) {
                      if (opponentError != null) {
                        setModalState(() => opponentError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Счёт *',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: auxText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          teamScoreController,
                          'Наша команда',
                          errorText: teamScoreError,
                          onChanged: (_) {
                            if (teamScoreError != null) {
                              setModalState(() => teamScoreError = null);
                            }
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildNumberField(
                          opponentScoreController,
                          'Соперник',
                          errorText: opponentScoreError,
                          onChanged: (_) {
                            if (opponentScoreError != null) {
                              setModalState(() => opponentScoreError = null);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    gameTimeController,
                    'Игровое время *',
                    Icons.timer,
                    hintText: 'Например, 60:00',
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                    ],
                    errorText: gameTimeError,
                    onChanged: (_) {
                      if (gameTimeError != null) {
                        setModalState(() => gameTimeError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(personalTasksController, 'Личные задачи на игру', Icons.task_alt, maxLines: 2),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      setModalState(() {
                        showAdvanced = !showAdvanced;
                      });
                    },
                    icon: Icon(
                      showAdvanced ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: primaryText,
                    ),
                    label: Text(
                      showAdvanced ? 'Скрыть параметры' : 'Показать расширенные параметры',
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                  ),
                  if (showAdvanced) ...[
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),
                    const Text(
                      'СТАТИСТИКА',
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildNumberField(goalsConcededController, 'Пропущено шайб'),
                    const SizedBox(height: 12),
                    _buildNumberField(savesController, 'Отражено бросков'),
                    const SizedBox(height: 16),
                    const Text(
                      'ОЦЕНКИ (1-5)',
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRatingSlider(context, setModalState, 'Настрой на игру', moodRating, (v) => setModalState(() => moodRating = v)),
                    _buildRatingSlider(context, setModalState, 'Разминка перед игрой', warmupRating, (v) => setModalState(() => warmupRating = v)),
                    _buildRatingSlider(context, setModalState, 'Уверенность во время игры', confidenceRating, (v) => setModalState(() => confidenceRating = v)),
                    _buildRatingSlider(context, setModalState, 'Хорошие спасения', greatSavesRating, (v) => setModalState(() => greatSavesRating = v)),
                    const SizedBox(height: 16),
                    _buildTextField(commentsController, 'Комментарии к игре', Icons.comment, maxLines: 3),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final normalizedGameTime =
                      _normalizeGameTime(gameTimeController.text);
                      final opponentIsEmpty =
                          opponentController.text.trim().isEmpty;
                      final teamScoreIsEmpty =
                          teamScoreController.text.trim().isEmpty;
                      final opponentScoreIsEmpty =
                          opponentScoreController.text.trim().isEmpty;

                      setModalState(() {
                        opponentError =
                        opponentIsEmpty ? 'Заполните поле' : null;
                        teamScoreError =
                        teamScoreIsEmpty ? 'Заполните поле' : null;
                        opponentScoreError =
                        opponentScoreIsEmpty ? 'Заполните поле' : null;
                        gameTimeError = gameTimeController.text.trim().isEmpty
                            ? 'Заполните поле'
                            : normalizedGameTime == null
                            ? 'Формат: 60:00'
                            : null;
                      });

                      if (opponentIsEmpty ||
                          teamScoreIsEmpty ||
                          opponentScoreIsEmpty ||
                          normalizedGameTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Заполните обязательные поля'),
                          ),
                        );
                        return;
                      }

                      gameTimeController.text = normalizedGameTime;
                      final teamScore = int.tryParse(teamScoreController.text) ?? 0;
                      final oppScore = int.tryParse(opponentScoreController.text) ?? 0;
                      final scoreString = '$teamScore:$oppScore';
                      await _addMatch(
                        goalkeeperId: _selectedGoalkeeper!.id,
                        date: matchDate,
                        opponent: opponentController.text.trim(),
                        score: scoreString,
                        gameTime: normalizedGameTime,
                        personalTasks: personalTasksController.text.trim().isNotEmpty
                            ? personalTasksController.text.trim()
                            : null,
                        goalsConceded: int.tryParse(goalsConcededController.text) ?? 0,
                        saves: int.tryParse(savesController.text) ?? 0,
                        moodRating: moodRating,
                        warmupRating: warmupRating,
                        confidenceRating: confidenceRating,
                        greatSavesRating: greatSavesRating,
                        comments: commentsController.text.trim().isNotEmpty
                            ? commentsController.text.trim()
                            : null,
                      );
                      if (mounted) Navigator.pop(context);
                    },
                    style: _primaryButtonStyle(),
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSlider(
      BuildContext context,
      void Function(void Function()) setModalState,
      String label,
      int value,
      Function(int) onChanged,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 14,
              color: primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: accentColor,
                  inactiveColor: auxText.withOpacity(0.3),
                  onChanged: (val) {
                    onChanged(val.toInt());
                  },
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addMatch({
    required int goalkeeperId,
    required DateTime date,
    required String opponent,
    String? score,
    String? gameTime,
    String? personalTasks,
    int goalsConceded = 0,
    int saves = 0,
    int? moodRating,
    int? warmupRating,
    int? confidenceRating,
    int? greatSavesRating,
    String? comments,
  }) async {
    final db = ref.read(databaseProvider);
    int duration = 60;
    if (gameTime != null) {
      try {
        final parts = gameTime.split(':');
        duration = int.parse(parts[0]);
      } catch (e) {
        duration = 60;
      }
    }
    double? savePercentage;
    final totalShots = goalsConceded + saves;
    if (totalShots > 0) {
      savePercentage = (saves / totalShots) * 100;
    }

    // ✅ ГЕНЕРАЦИЯ UUID
    final uuid = const Uuid().v4();

    final match = MatchesCompanion.insert(
      uuid: uuid,
      goalkeeperId: goalkeeperId,
      date: date,
      opponent: opponent,
      score: Value(score),
      gameTime: Value(gameTime),
      personalTasks: Value(personalTasks),
      gameDuration: Value(duration),
      goalsConceded: Value(goalsConceded),
      saves: Value(saves),
      savePercentage: Value(savePercentage),
      moodRating: Value(moodRating),
      warmupRating: Value(warmupRating),
      confidenceRating: Value(confidenceRating),
      greatSavesRating: Value(greatSavesRating),
      comments: Value(comments),
    );
    await db.insertMatch(match);
    await _loadMatchesForDate();
  }

  Future<void> _deleteMatch(Matche match) async {
    final db = ref.read(databaseProvider);
    await db.deleteMatch(match.id);
    await _loadMatchesForDate();
  }

  Future<void> _navigateToGoalList(Matche match) async {
    final hand = _selectedGoalkeeper?.hand ?? 'right';

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalListScreen(match: match, hand: hand,),
      ),
    );
    await _loadMatchesForDate();
  }

  Future<void> _openGoalListFromButton(Matche match) async {
    if (_pressedGoalsMatchId != null) return;

    setState(() {
      _pressedGoalsMatchId = match.id;
    });

    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (!mounted) return;

    try {
      await _navigateToGoalList(match);
    } finally {
      if (mounted) {
        setState(() {
          _pressedGoalsMatchId = null;
        });
      }
    }
  }

  void _editMatch(Matche match) {
    DateTime matchDate = match.date;
    final opponentController = TextEditingController(text: match.opponent);
    int teamScore = 0;
    int opponentScore = 0;
    if (match.score != null && match.score!.contains(':')) {
      final parts = match.score!.split(':');
      teamScore = int.tryParse(parts[0]) ?? 0;
      opponentScore = int.tryParse(parts[1]) ?? 0;
    }
    final teamScoreController = TextEditingController(text: teamScore.toString());
    final opponentScoreController = TextEditingController(text: opponentScore.toString());
    final gameTimeController = TextEditingController(text: match.gameTime ?? '');
    final personalTasksController = TextEditingController(text: match.personalTasks ?? '');
    final goalsConcededController = TextEditingController(text: match.goalsConceded.toString());
    final savesController = TextEditingController(text: match.saves.toString());
    final commentsController = TextEditingController(text: match.comments ?? '');
    int moodRating = match.moodRating ?? 3;
    int warmupRating = match.warmupRating ?? 3;
    int confidenceRating = match.confidenceRating ?? 3;
    int greatSavesRating = match.greatSavesRating ?? 3;
    bool showAdvanced = false;
    String? opponentError;
    String? teamScoreError;
    String? opponentScoreError;
    String? gameTimeError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Theme(
        data: _diaryTheme(sheetContext),
        child: StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Редактировать игру',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Обязательные поля отмечены *',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13,
                      color: auxText,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMatchDateField(
                    date: matchDate,
                    onTap: () async {
                      final picked = await _pickMatchDate(context, matchDate);
                      if (!context.mounted || picked == null) return;
                      setModalState(() => matchDate = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    opponentController,
                    'Соперник *',
                    Icons.sports_hockey,
                    errorText: opponentError,
                    onChanged: (_) {
                      if (opponentError != null) {
                        setModalState(() => opponentError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Счёт *',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: auxText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildNumberField(
                          teamScoreController,
                          'Наша команда',
                          errorText: teamScoreError,
                          onChanged: (_) {
                            if (teamScoreError != null) {
                              setModalState(() => teamScoreError = null);
                            }
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildNumberField(
                          opponentScoreController,
                          'Соперник',
                          errorText: opponentScoreError,
                          onChanged: (_) {
                            if (opponentScoreError != null) {
                              setModalState(() => opponentScoreError = null);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    gameTimeController,
                    'Игровое время *',
                    Icons.timer,
                    hintText: 'Например, 60:00',
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                    ],
                    errorText: gameTimeError,
                    onChanged: (_) {
                      if (gameTimeError != null) {
                        setModalState(() => gameTimeError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(personalTasksController, 'Личные задачи на игру', Icons.task_alt, maxLines: 2),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => setModalState(() => showAdvanced = !showAdvanced),
                    icon: Icon(showAdvanced ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: primaryText),
                    label: Text(
                      showAdvanced ? 'Скрыть параметры' : 'Показать расширенные параметры',
                      style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
                    ),
                  ),
                  if (showAdvanced) ...[
                    const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),
                    const Text('СТАТИСТИКА', style: TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.bold, color: primaryText)),
                    const SizedBox(height: 12),
                    _buildNumberField(goalsConcededController, 'Пропущено шайб'),
                    const SizedBox(height: 12),
                    _buildNumberField(savesController, 'Отражено бросков'),
                    const SizedBox(height: 16),
                    const Text('ОЦЕНКИ (1-5)', style: TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.bold, color: primaryText)),
                    const SizedBox(height: 12),
                    _buildRatingSlider(context, setModalState, 'Настрой на игру', moodRating, (v) => setModalState(() => moodRating = v)),
                    _buildRatingSlider(context, setModalState, 'Разминка перед игрой', warmupRating, (v) => setModalState(() => warmupRating = v)),
                    _buildRatingSlider(context, setModalState, 'Уверенность во время игры', confidenceRating, (v) => setModalState(() => confidenceRating = v)),
                    _buildRatingSlider(context, setModalState, 'Хорошие спасения', greatSavesRating, (v) => setModalState(() => greatSavesRating = v)),
                    const SizedBox(height: 16),
                    _buildTextField(commentsController, 'Комментарии к игре', Icons.comment, maxLines: 3),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final normalizedGameTime =
                      _normalizeGameTime(gameTimeController.text);
                      final opponentIsEmpty =
                          opponentController.text.trim().isEmpty;
                      final teamScoreIsEmpty =
                          teamScoreController.text.trim().isEmpty;
                      final opponentScoreIsEmpty =
                          opponentScoreController.text.trim().isEmpty;

                      setModalState(() {
                        opponentError =
                        opponentIsEmpty ? 'Заполните поле' : null;
                        teamScoreError =
                        teamScoreIsEmpty ? 'Заполните поле' : null;
                        opponentScoreError =
                        opponentScoreIsEmpty ? 'Заполните поле' : null;
                        gameTimeError = gameTimeController.text.trim().isEmpty
                            ? 'Заполните поле'
                            : normalizedGameTime == null
                            ? 'Формат: 60:00'
                            : null;
                      });

                      if (opponentIsEmpty ||
                          teamScoreIsEmpty ||
                          opponentScoreIsEmpty ||
                          normalizedGameTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Заполните обязательные поля'),
                          ),
                        );
                        return;
                      }

                      gameTimeController.text = normalizedGameTime;
                      final db = ref.read(databaseProvider);
                      final duration =
                      int.parse(normalizedGameTime.split(':')[0]);
                      final conceded = int.tryParse(goalsConcededController.text) ?? 0;
                      final saves = int.tryParse(savesController.text) ?? 0;
                      final total = conceded + saves;
                      final teamScore = int.tryParse(teamScoreController.text) ?? 0;
                      final oppScore = int.tryParse(opponentScoreController.text) ?? 0;
                      final scoreString = '$teamScore:$oppScore';
                      final updatedMatch = Matche(
                        id: match.id,
                        uuid: match.uuid, // ✅ ВАЖНО: сохраняем существующий UUID
                        goalkeeperId: match.goalkeeperId,
                        date: matchDate,
                        opponent: opponentController.text.trim(),
                        score: scoreString,
                        gameTime: normalizedGameTime,
                        personalTasks: personalTasksController.text.trim().isNotEmpty ? personalTasksController.text.trim() : null,
                        gameDuration: duration,
                        goalsConceded: conceded,
                        saves: saves,
                        savePercentage: total > 0 ? (saves / total) * 100 : null,
                        moodRating: moodRating,
                        warmupRating: warmupRating,
                        confidenceRating: confidenceRating,
                        greatSavesRating: greatSavesRating,
                        comments: commentsController.text.trim().isNotEmpty ? commentsController.text.trim() : null,
                        createdAt: match.createdAt,
                      );
                      await db.updateMatch(updatedMatch);
                      if (mounted) {
                        Navigator.pop(context);
                        await _loadMatchesForDate();
                      }
                    },
                    style: _primaryButtonStyle(),
                    child: const Text('Обновить'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool isNumber = false,
        int maxLines = 1,
        String? hintText,
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
        String? errorText,
        ValueChanged<String>? onChanged,
      }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasValue = value.text.trim().isNotEmpty;
        final hasError = errorText != null;
        final borderColor = hasError
            ? Colors.red
            : hasValue
            ? accentColor
            : borderGrey;
        final borderWidth = hasError || hasValue ? 2.0 : 1.4;

        return TextField(
          controller: controller,
          keyboardType: keyboardType ??
              (isNumber ? TextInputType.number : TextInputType.text),
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          maxLines: maxLines,
          cursorColor: primaryText,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
            color: primaryText,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            errorText: errorText,
            hintStyle: const TextStyle(
              fontFamily: 'Lato',
              color: auxText,
            ),
            labelStyle: const TextStyle(
              fontFamily: 'Lato',
              color: auxText,
            ),
            floatingLabelStyle: const TextStyle(
              fontFamily: 'Lato',
              color: primaryText,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: inputBg,
            prefixIcon: Icon(icon, color: primaryText),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: hasError ? Colors.red : accentColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: borderGrey, width: 1.4),
            ),
          ),
        );
      },
    );
  }

  String? _normalizeGameTime(String value) {
    final trimmed = value.trim();

    if (RegExp(r'^\d+$').hasMatch(trimmed)) {
      final minutes = int.tryParse(trimmed);
      return minutes == null ? null : '$minutes:00';
    }

    final match = RegExp(r'^(\d+):(\d{1,2})$').firstMatch(trimmed);
    if (match == null) return null;

    final minutes = int.tryParse(match.group(1)!);
    final seconds = int.tryParse(match.group(2)!);
    if (minutes == null || seconds == null || seconds > 59) return null;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }


  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();

    setState(() {
      _isPeriodPickerOpen = true;
      _showManualPeriodInput = false;
      _periodStartError = null;
      _periodEndError = null;

      _periodStartDate = _selectedDateRange == null
          ? null
          : _normalizePeriodDay(_selectedDateRange!.start);

      _periodEndDate = _selectedDateRange == null
          ? null
          : _normalizePeriodDay(_selectedDateRange!.end);

      final DateTime baseDate = _periodStartDate ?? now;

      _periodVisibleMonth = DateTime(
        baseDate.year,
        baseDate.month,
      );

      _periodStartController.text = _periodStartDate == null
          ? ''
          : DateFormat('dd.MM.yyyy').format(_periodStartDate!);

      _periodEndController.text = _periodEndDate == null
          ? ''
          : DateFormat('dd.MM.yyyy').format(_periodEndDate!);
    });
  }

  DateTime _normalizePeriodDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSamePeriodDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool _isPeriodDateEnabled(DateTime date) {
    final day = _normalizePeriodDay(date);
    final first = DateTime(2020, 1, 1);
    final last = DateTime(2100, 12, 31);

    return !day.isBefore(first) && !day.isAfter(last);
  }

  bool _isPeriodDateInRange(DateTime date) {
    if (_periodStartDate == null || _periodEndDate == null) {
      return false;
    }

    final day = _normalizePeriodDay(date);

    return !day.isBefore(_periodStartDate!) &&
        !day.isAfter(_periodEndDate!);
  }

  bool _isPeriodStart(DateTime date) {
    return _periodStartDate != null &&
        _isSamePeriodDay(date, _periodStartDate!);
  }

  bool _isPeriodEnd(DateTime date) {
    return _periodEndDate != null &&
        _isSamePeriodDay(date, _periodEndDate!);
  }

  void _selectPeriodDay(DateTime date) {
    if (!_isPeriodDateEnabled(date)) return;

    final selected = _normalizePeriodDay(date);

    setState(() {
      _showManualPeriodInput = false;
      _periodStartError = null;
      _periodEndError = null;

      if (_periodStartDate == null || _periodEndDate != null) {
        _periodStartDate = selected;
        _periodEndDate = null;
      } else if (selected.isBefore(_periodStartDate!)) {
        _periodEndDate = _periodStartDate;
        _periodStartDate = selected;
      } else {
        _periodEndDate = selected;
      }

      _periodStartController.text = _periodStartDate == null
          ? ''
          : DateFormat('dd.MM.yyyy').format(_periodStartDate!);

      _periodEndController.text = _periodEndDate == null
          ? ''
          : DateFormat('dd.MM.yyyy').format(_periodEndDate!);
    });
  }

  bool get _canGoToPreviousPeriodMonth {
    final previous = DateTime(
      _periodVisibleMonth.year,
      _periodVisibleMonth.month - 1,
    );

    return !previous.isBefore(DateTime(2020, 1));
  }

  bool get _canGoToNextPeriodMonth {
    final next = DateTime(
      _periodVisibleMonth.year,
      _periodVisibleMonth.month + 1,
    );

    return !next.isAfter(DateTime(2100, 12));
  }

  void _goToPreviousPeriodMonth() {
    if (!_canGoToPreviousPeriodMonth) return;

    setState(() {
      _periodVisibleMonth = DateTime(
        _periodVisibleMonth.year,
        _periodVisibleMonth.month - 1,
      );
    });
  }

  void _goToNextPeriodMonth() {
    if (!_canGoToNextPeriodMonth) return;

    setState(() {
      _periodVisibleMonth = DateTime(
        _periodVisibleMonth.year,
        _periodVisibleMonth.month + 1,
      );
    });
  }

  DateTime? _parsePeriodDate(String value) {
    try {
      return _normalizePeriodDay(
        DateFormat('dd.MM.yyyy').parseStrict(value.trim()),
      );
    } on FormatException {
      return null;
    }
  }

  String? _validateManualPeriodDate(String value) {
    if (value.trim().isEmpty) {
      return 'Введите дату';
    }

    final date = _parsePeriodDate(value);

    if (date == null) {
      return 'Формат: ДД.ММ.ГГГГ';
    }

    if (!_isPeriodDateEnabled(date)) {
      return 'Дата вне допустимого периода';
    }

    return null;
  }

  void _toggleManualPeriodInput() {
    if (!_showManualPeriodInput) {
      setState(() {
        _showManualPeriodInput = true;
        _periodStartError = null;
        _periodEndError = null;
        _periodStartController.text = _periodStartDate == null
            ? ''
            : DateFormat('dd.MM.yyyy').format(_periodStartDate!);

        _periodEndController.text = _periodEndDate == null
            ? ''
            : DateFormat('dd.MM.yyyy').format(_periodEndDate!);
      });
      return;
    }

    final startText = _periodStartController.text;
    final endText = _periodEndController.text;
    final startError = _validateManualPeriodDate(startText);
    final endError = _validateManualPeriodDate(endText);
    final start = _parsePeriodDate(startText);
    final end = _parsePeriodDate(endText);
    final rangeError = startError == null &&
        endError == null &&
        start != null &&
        end != null &&
        end.isBefore(start)
        ? 'Дата окончания раньше начала'
        : null;

    if (startError != null || endError != null || rangeError != null) {
      setState(() {
        _periodStartError = startError;
        _periodEndError = rangeError ?? endError;
      });
      return;
    }

    setState(() {
      _periodStartDate = start;
      _periodEndDate = end;
      _periodVisibleMonth = DateTime(start!.year, start!.month);
      _showManualPeriodInput = false;
      _periodStartError = null;
      _periodEndError = null;
    });
  }

  bool get _canApplyPeriod {
    if (_showManualPeriodInput) {
      final start = _parsePeriodDate(_periodStartController.text);
      final end = _parsePeriodDate(_periodEndController.text);

      return start != null &&
          end != null &&
          _isPeriodDateEnabled(start) &&
          _isPeriodDateEnabled(end) &&
          !end.isBefore(start);
    }

    return _periodStartDate != null && _periodEndDate != null;
  }

  Future<void> _applyPeriod() async {
    DateTime? start = _periodStartDate;
    DateTime? end = _periodEndDate;

    if (_showManualPeriodInput) {
      final startText = _periodStartController.text;
      final endText = _periodEndController.text;

      final startError = _validateManualPeriodDate(startText);
      final endError = _validateManualPeriodDate(endText);

      start = _parsePeriodDate(startText);
      end = _parsePeriodDate(endText);

      if (startError == null &&
          endError == null &&
          start != null &&
          end != null &&
          end.isBefore(start)) {
        setState(() {
          _periodStartError = null;
          _periodEndError = 'Дата окончания раньше начала';
        });
        return;
      }

      if (startError != null || endError != null) {
        setState(() {
          _periodStartError = startError;
          _periodEndError = endError;
        });
        return;
      }
    }

    if (start == null || end == null) return;

    setState(() {
      _selectedDateRange = DateTimeRange(
        start: start!,
        end: end!,
      );
      _showAllMatches = false;
      _isPeriodPickerOpen = false;
      _showManualPeriodInput = false;
      _periodStartError = null;
      _periodEndError = null;
    });

    await _loadMatchesForDate();
  }

  void _closePeriodPicker() {
    setState(() {
      _isPeriodPickerOpen = false;
      _showManualPeriodInput = false;
      _periodStartError = null;
      _periodEndError = null;
    });
  }

  String _formatPeriodHeaderDate(DateTime date) {
    final months = <String>[
      'янв.',
      'февр.',
      'мар.',
      'апр.',
      'мая',
      'июн.',
      'июл.',
      'авг.',
      'сент.',
      'окт.',
      'нояб.',
      'дек.',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get _periodHeaderLabel {
    if (_periodStartDate == null) {
      return 'Дата начала — Дата окончания';
    }

    if (_periodEndDate == null) {
      return '${_formatPeriodHeaderDate(_periodStartDate!)} — Дата окончания';
    }

    return '${_formatPeriodHeaderDate(_periodStartDate!)} — '
        '${_formatPeriodHeaderDate(_periodEndDate!)}';
  }

  String _periodMonthTitle(DateTime month) {
    const months = <String>[
      'ЯНВАРЬ',
      'ФЕВРАЛЬ',
      'МАРТ',
      'АПРЕЛЬ',
      'МАЙ',
      'ИЮНЬ',
      'ИЮЛЬ',
      'АВГУСТ',
      'СЕНТЯБРЬ',
      'ОКТЯБРЬ',
      'НОЯБРЬ',
      'ДЕКАБРЬ',
    ];

    return '${months[month.month - 1]} ${month.year}';
  }

  Widget _buildPeriodPickerScreen(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _closePeriodPicker();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Закрыть',
            onPressed: _closePeriodPicker,
            icon: const Icon(
              Icons.close,
              color: primaryText,
            ),
          ),
          titleSpacing: 0,
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'ВЫБЕРИТЕ ПЕРИОД',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: primaryText,
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      8,
                      horizontalPadding,
                      10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            _periodHeaderLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15,
                              height: 1.35,
                              fontWeight: FontWeight.w400,
                              color: primaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          onPressed: _toggleManualPeriodInput,
                          style: TextButton.styleFrom(
                            foregroundColor: primaryText,
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: const TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: Icon(
                            _showManualPeriodInput
                                ? Icons.calendar_month_outlined
                                : Icons.edit_outlined,
                            size: 17,
                          ),
                          label: Text(
                            _showManualPeriodInput
                                ? 'К календарю'
                                : 'Ввести даты',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFEEEEEE),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        24,
                      ),
                      child: _showManualPeriodInput
                          ? _buildManualPeriodFields()
                          : _buildPeriodCalendarCard(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                12,
              ),
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 648),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _closePeriodPicker,
                        style: const ButtonStyle(
                          minimumSize: WidgetStatePropertyAll<Size>(
                            Size(0, 48),
                          ),
                          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          foregroundColor:
                          WidgetStatePropertyAll<Color>(auxText),
                          overlayColor: WidgetStatePropertyAll<Color>(
                            Color(0x0D121A1F),
                          ),
                          textStyle: WidgetStatePropertyAll<TextStyle>(
                            TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        child: const Text('Отмена'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _showManualPeriodInput || _canApplyPeriod
                                ? _applyPeriod
                                : null,
                            style: ButtonStyle(
                              elevation:
                              const WidgetStatePropertyAll<double>(0),
                              shape:
                              const WidgetStatePropertyAll<OutlinedBorder>(
                                StadiumBorder(),
                              ),
                              backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return const Color(0xFFE3E4E8);
                                  }
                                  if (states.contains(WidgetState.pressed) ||
                                      states.contains(WidgetState.focused)) {
                                    return accentColor;
                                  }
                                  return darkButton;
                                },
                              ),
                              foregroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return auxText;
                                  }
                                  if (states.contains(WidgetState.pressed) ||
                                      states.contains(WidgetState.focused)) {
                                    return primaryText;
                                  }
                                  return Colors.white;
                                },
                              ),
                              overlayColor:
                              const WidgetStatePropertyAll<Color>(
                                Colors.transparent,
                              ),
                              textStyle:
                              const WidgetStatePropertyAll<TextStyle>(
                                TextStyle(
                                  fontFamily: 'Unbounded',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Применить',
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManualPeriodFields() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ВВЕДИТЕ ДАТЫ',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _periodStartController,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.next,
            cursorColor: primaryText,
            onChanged: (_) {
              setState(() {
                _periodStartError = null;
              });
            },
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: primaryText,
            ),
            decoration: InputDecoration(
              labelText: 'Дата начала',
              hintText: 'ДД.ММ.ГГГГ',
              errorText: _periodStartError,
              labelStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: auxText,
              ),
              floatingLabelStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: primaryText,
              ),
              hintStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: auxText,
              ),
              filled: true,
              fillColor: inputBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: borderGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: accentColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _periodEndController,
            keyboardType: TextInputType.datetime,
            cursorColor: primaryText,
            onChanged: (_) {
              setState(() {
                _periodEndError = null;
              });
            },
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: primaryText,
            ),
            decoration: InputDecoration(
              labelText: 'Дата окончания',
              hintText: 'ДД.ММ.ГГГГ',
              errorText: _periodEndError,
              labelStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: auxText,
              ),
              floatingLabelStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: primaryText,
              ),
              hintStyle: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: auxText,
              ),
              filled: true,
              fillColor: inputBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: borderGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: accentColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Формат даты: ДД.ММ.ГГГГ',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: auxText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodCalendarCard() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _periodVisibleMonth.year,
      _periodVisibleMonth.month,
    );

    final firstDayOfMonth = DateTime(
      _periodVisibleMonth.year,
      _periodVisibleMonth.month,
      1,
    );

    final firstWeekdayOffset = firstDayOfMonth.weekday - 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderGrey),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildPeriodMonthNavigationButton(
                icon: Icons.chevron_left,
                enabled: _canGoToPreviousPeriodMonth,
                onTap: _goToPreviousPeriodMonth,
                tooltip: 'Предыдущий месяц',
              ),
              Expanded(
                child: Text(
                  _periodMonthTitle(_periodVisibleMonth),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
              ),
              _buildPeriodMonthNavigationButton(
                icon: Icons.chevron_right,
                enabled: _canGoToNextPeriodMonth,
                onTap: _goToNextPeriodMonth,
                tooltip: 'Следующий месяц',
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              _PeriodWeekDay('П'),
              _PeriodWeekDay('В'),
              _PeriodWeekDay('С'),
              _PeriodWeekDay('Ч'),
              _PeriodWeekDay('П'),
              _PeriodWeekDay('С'),
              _PeriodWeekDay('В'),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dayNumber =
                  index - firstWeekdayOffset + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox();
              }

              final date = DateTime(
                _periodVisibleMonth.year,
                _periodVisibleMonth.month,
                dayNumber,
              );

              return _buildPeriodDayCell(date);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodMonthNavigationButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: enabled ? onTap : null,
      icon: Icon(
        icon,
        color: enabled ? primaryText : borderGrey,
      ),
    );
  }

  Widget _buildPeriodDayCell(DateTime date) {
    final enabled = _isPeriodDateEnabled(date);
    final isStart = _isPeriodStart(date);
    final isEnd = _isPeriodEnd(date);
    final isBoundary = isStart || isEnd;
    final isInRange = _isPeriodDateInRange(date);
    final isToday = _isSamePeriodDay(
      date,
      _normalizePeriodDay(DateTime.now()),
    );

    return Semantics(
      button: enabled,
      selected: isBoundary || isInRange,
      label: '${date.day}.${date.month}.${date.year}',
      child: InkWell(
        onTap: enabled ? () => _selectPeriodDay(date) : null,
        borderRadius: BorderRadius.circular(24),
        splashColor: softLime,
        highlightColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            alignment: Alignment.center,
            children: [
              if (isInRange)
                Positioned(
                  left: isStart ? constraints.maxWidth / 2 : 0,
                  right: isEnd ? constraints.maxWidth / 2 : 0,
                  top: 9,
                  bottom: 9,
                  child: Container(
                    color: softLime,
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isBoundary
                      ? accentColor
                      : isToday
                      ? const Color(0x14BBF246)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday && !isBoundary
                      ? Border.all(
                    color: const Color(0x33BBF246),
                    width: 1,
                  )
                      : null,
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: enabled ? primaryText : borderGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(
      TextEditingController controller,
      String label, {
        String? errorText,
        ValueChanged<String>? onChanged,
      }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasValue = value.text.trim().isNotEmpty;
        final hasError = errorText != null;
        final borderColor = hasError
            ? Colors.red
            : hasValue
            ? accentColor
            : borderGrey;
        final borderWidth = hasError || hasValue ? 2.0 : 1.4;

        return TextField(
          controller: controller,
          keyboardType: TextInputType.number, // ✅ Открывает цифровую клавиатуру
          textAlign: TextAlign.center,
          cursorColor: primaryText,
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 24, // ✅ Чуть крупнее для удобства нажатия
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: '0',
            errorText: errorText,
            errorStyle: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 10,
              color: Colors.red,
            ),
            labelStyle: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 12,
              color: auxText,
            ),
            floatingLabelStyle: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 12,
              color: primaryText,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: inputBg,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: hasError ? Colors.red : accentColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: borderGrey, width: 1.4),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          // ✅ ПРИ ТАПЕ выделяет весь текущий текст (не нужно вручную стирать "0")
          onTap: () {
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          },
          // ✅ Блокирует ввод всего, кроме цифр
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          // ✅ По нажатию "Далее" переводит фокус на следующее поле
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? primaryText : auxText,
              ),
              const SizedBox(width: 7),
            ],
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? primaryText : auxText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isPeriodPickerOpen) {
      return Theme(
        data: _diaryTheme(context),
        child: _buildPeriodPickerScreen(context),
      );
    }

    final dateFormat = DateFormat('dd.MM.yyyy');
    final periodLabel = _selectedDateRange == null
        ? 'Выбрать период'
        : '${dateFormat.format(_selectedDateRange!.start)} — '
        '${dateFormat.format(_selectedDateRange!.end)}';

    return Theme(
      data: _diaryTheme(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: primaryText),
            onPressed: () => Navigator.pop(context),
          ),
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'ДНЕВНИК ГОЛОВ',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryText,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
          top: false,
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Фильтр по всем играм или выбранному периоду
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildFilterButton(
                              label: 'Все игры',
                              isSelected: _showAllMatches,
                              onTap: () async {
                                setState(() {
                                  _showAllMatches = true;
                                  _selectedDateRange = null;
                                });
                                await _loadMatchesForDate();
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            flex: 2,
                            child: _buildFilterButton(
                              label: periodLabel,
                              icon: Icons.date_range_outlined,
                              isSelected: !_showAllMatches,
                              onTap: _selectDateRange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🟢 Выбор вратаря
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 58),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
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
                              initialValue: _selectedGoalkeeper,
                              position: PopupMenuPosition.under,
                              offset: const Offset(0, 12),
                              color: popupMenuBg,
                              surfaceTintColor: Colors.transparent,
                              shadowColor: Colors.black12,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  popupMenuRadius,
                                ),
                              ),
                              constraints: BoxConstraints(
                                maxWidth: (MediaQuery.of(context).size.width - 32)
                                    .clamp(0.0, 320.0).toDouble(),
                              ),
                              onSelected: (Goalkeeper newValue) async {
                                setState(() {
                                  _selectedGoalkeeper = newValue;
                                });
                                await _loadMatchesForDate();
                              },
                              itemBuilder: (context) {
                                return _goalkeepers.map((keeper) {
                                  final bool isSelected =
                                      keeper.id == _selectedGoalkeeper?.id;

                                  return PopupMenuItem<Goalkeeper>(
                                    value: keeper,
                                    height: popupMenuItemHeight,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          color: isSelected
                                              ? primaryText
                                              : auxText,
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
                                        '${_selectedGoalkeeper!.firstName} '
                                            '${_selectedGoalkeeper!.lastName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Unbounded',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: primaryText,
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

                  // 📋 Список игр
                  Expanded(
                    child: _matches.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sports_hockey, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            _showAllMatches
                                ? 'Нет игр у этого вратаря'
                                : 'Нет игр за выбранный период',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _matches.length,
                      itemBuilder: (context, index) {
                        final match = _matches[index];
                        final isGoalsButtonPressed =
                            _pressedGoalsMatchId == match.id;
                        // Внутри ListView.builder -> itemBuilder

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderGrey, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'ИГРА С ${match.opponent.toUpperCase()}',
                                softWrap: true,
                                style: const TextStyle(
                                  fontFamily: 'Unbounded',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        color: auxText,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          DateFormat('dd.MM.yyyy').format(match.date),
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: auxText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Счёт: ${match.score ?? "0:0"}',
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: auxText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Semantics(
                                      button: true,
                                      label: 'Указать голы',
                                      excludeSemantics: true,
                                      onTap: () => _openGoalListFromButton(match),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 140),
                                        curve: Curves.easeOut,
                                        constraints: const BoxConstraints(minHeight: 48),
                                        decoration: BoxDecoration(
                                          color: isGoalsButtonPressed
                                              ? darkButton
                                              : inputBg,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(16),
                                          child: InkWell(
                                            onTap: () => _openGoalListFromButton(match),
                                            borderRadius: BorderRadius.circular(16),
                                            splashColor: Colors.white.withOpacity(0.14),
                                            highlightColor: Colors.transparent,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 14,
                                              ),
                                              child: AnimatedSwitcher(
                                                duration:
                                                const Duration(milliseconds: 140),
                                                child: Row(
                                                  key: ValueKey(isGoalsButtonPressed),
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.sports_hockey,
                                                      color: isGoalsButtonPressed
                                                          ? Colors.white
                                                          : primaryText,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        'Указать голы',
                                                        textAlign: TextAlign.center,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          fontFamily: 'Unbounded',
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: isGoalsButtonPressed
                                                              ? Colors.white
                                                              : primaryText,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: borderGrey),
                                    ),
                                    child: PopupMenuButton<String>(
                                      tooltip: 'Действия с игрой',
                                      position: PopupMenuPosition.under,
                                      offset: const Offset(0, 22),
                                      color: popupMenuBg,
                                      surfaceTintColor: Colors.transparent,
                                      shadowColor: Colors.black12,
                                      elevation: 8,
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: primaryText,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(popupMenuRadius),
                                      ),
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          _deleteMatch(match);
                                        } else if (value == 'edit') {
                                          _editMatch(match);
                                        } else if (value == 'goals') {
                                          _navigateToGoalList(match);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          height: popupMenuItemHeight,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit_outlined,
                                                color: primaryText,
                                                size: 19,
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  'Редактировать',
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    color: primaryText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'goals',
                                          height: popupMenuItemHeight,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.sports_hockey,
                                                color: primaryText,
                                                size: 19,
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  'Указать голы',
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    color: primaryText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          height: popupMenuItemHeight,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 19,
                                              ),
                                              SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  'Удалить',
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 648),
                  child: Semantics(
                    button: true,
                    label: 'Добавить игру',
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isAddButtonPressed = true;
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isAddButtonPressed = false;
                        });
                      },
                      onTap: () async {
                        await _showAddMatchDialog();

                        if (!mounted) return;

                        setState(() {
                          _isAddButtonPressed = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        constraints: const BoxConstraints(minHeight: 56),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                        decoration: BoxDecoration(
                          color: _isAddButtonPressed ? accentColor : darkButton,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: _isAddButtonPressed ? primaryText : Colors.white,
                            ),
                            const SizedBox(width: 9),
                            Flexible(child: Text(
                              'Добавить игру',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Unbounded',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _isAddButtonPressed ? primaryText : Colors.white,
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _PeriodWeekDay extends StatelessWidget {
  final String label;

  const _PeriodWeekDay(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9B9EA1),
          ),
        ),
      ),
    );
  }
}
