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
  DateTime _selectedDate = DateTime.now();
  List<Goalkeeper> _goalkeepers = [];
  Goalkeeper? _selectedGoalkeeper;
  List<Matche> _matches = [];
  bool _isLoading = true;
  bool _showAllMatches = false;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color darkButton = Color(0xFF121212);
  static const double borderRadius = 15.0;

  @override
  void initState() {
    super.initState();
    _loadData();
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
      if (_showAllMatches) {
        // Если галочка стоит - грузим ВСЕ игры вратаря
        matches = await db.getMatchesByGoalkeeper(_selectedGoalkeeper!.id);
      } else {
        // Если галочка снята - грузим только за выбранную дату
        matches = await db.getMatchesByDate(_selectedGoalkeeper!.id, _selectedDate);
      }
    } catch (e) {
      print('Ошибка загрузки игр: $e');
    }

    setState(() {
      _matches = matches;
      _isLoading = false;
    });
  }

  void _showAddMatchDialog() {
    if (_selectedGoalkeeper == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала выберите вратаря')),
      );
      return;
    }
    final opponentController = TextEditingController();
    final teamScoreController = TextEditingController(text: '0');
    final opponentScoreController = TextEditingController(text: '0');
    final gameTimeController = TextEditingController(text: '60:00');
    final personalTasksController = TextEditingController();
    final goalsConcededController = TextEditingController(text: '0');
    final savesController = TextEditingController(text: '0');
    final commentsController = TextEditingController();
    int moodRating = 3;
    int warmupRating = 3;
    int confidenceRating = 3;
    int greatSavesRating = 3;
    bool showAdvanced = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
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
                const SizedBox(height: 20),
                _buildTextField(opponentController, 'Соперник', Icons.sports_hockey),
                const SizedBox(height: 12),
                const Text(
                  'Счёт',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    color: auxText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(teamScoreController, 'Наша команда'),
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
                      child: _buildNumberField(opponentScoreController, 'Соперник'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(gameTimeController, 'Игровое время', Icons.timer),
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
                    color: accentColor,
                  ),
                  label: Text(
                    showAdvanced ? 'Скрыть параметры' : 'Показать расширенные параметры',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
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
                    if (opponentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите соперника')),
                      );
                      return;
                    }
                    final teamScore = int.tryParse(teamScoreController.text) ?? 0;
                    final oppScore = int.tryParse(opponentScoreController.text) ?? 0;
                    final scoreString = '$teamScore:$oppScore';
                    await _addMatch(
                      goalkeeperId: _selectedGoalkeeper!.id,
                      date: _selectedDate,
                      opponent: opponentController.text.trim(),
                      score: scoreString,
                      gameTime: gameTimeController.text.trim().isNotEmpty
                          ? gameTimeController.text.trim()
                          : null,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkButton,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'СОХРАНИТЬ',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
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

  void _navigateToGoalList(Matche match) {

    final hand = _selectedGoalkeeper?.hand ?? 'right';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalListScreen(match: match, hand: hand,),
      ),
    ).then((_) => _loadMatchesForDate());
  }

  void _editMatch(Matche match) {
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
    final gameTimeController = TextEditingController(text: match.gameTime ?? '60:00');
    final personalTasksController = TextEditingController(text: match.personalTasks ?? '');
    final goalsConcededController = TextEditingController(text: match.goalsConceded.toString());
    final savesController = TextEditingController(text: match.saves.toString());
    final commentsController = TextEditingController(text: match.comments ?? '');
    int moodRating = match.moodRating ?? 3;
    int warmupRating = match.warmupRating ?? 3;
    int confidenceRating = match.confidenceRating ?? 3;
    int greatSavesRating = match.greatSavesRating ?? 3;
    bool showAdvanced = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
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
                  'РЕДАКТИРОВАТЬ ИГРУ',
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTextField(opponentController, 'Соперник', Icons.sports_hockey),
                const SizedBox(height: 12),
                const Text(
                  'Счёт',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    color: auxText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(teamScoreController, 'Наша команда'),
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
                      child: _buildNumberField(opponentScoreController, 'Соперник'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(gameTimeController, 'Игровое время', Icons.timer),
                const SizedBox(height: 12),
                _buildTextField(personalTasksController, 'Личные задачи на игру', Icons.task_alt, maxLines: 2),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => setModalState(() => showAdvanced = !showAdvanced),
                  icon: Icon(showAdvanced ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: accentColor),
                  label: Text(
                    showAdvanced ? 'Скрыть параметры' : 'Показать расширенные параметры',
                    style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.w600, color: accentColor),
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
                    final db = ref.read(databaseProvider);
                    int duration = 60;
                    try {
                      duration = int.parse(gameTimeController.text.split(':')[0]);
                    } catch (_) {}
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
                      date: match.date,
                      opponent: opponentController.text.trim(),
                      score: scoreString,
                      gameTime: gameTimeController.text.trim().isNotEmpty ? gameTimeController.text.trim() : null,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text('ОБНОВИТЬ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.w600, color: primaryText)),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: inputBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, color: primaryText),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number, // ✅ Открывает цифровую клавиатуру
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 24, // ✅ Чуть крупнее для удобства нажатия
        fontWeight: FontWeight.bold,
        color: primaryText,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 12,
          color: auxText,
        ),
        filled: true,
        fillColor: inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
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
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final dayFormat = DateFormat('EEEE', 'ru_RU');

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Блок с датой и ГАЛОЧКОЙ
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                // Клик по дате открывает календарь
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() => _selectedDate = picked);
                        // Если меняем дату, автоматически снимаем галочку "Все игры",
                        // чтобы пользователь видел результат выбора даты
                        if (_showAllMatches) {
                          setState(() => _showAllMatches = false);
                        }
                        await _loadMatchesForDate();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${dayFormat.format(_selectedDate)}, ${dateFormat.format(_selectedDate)}',
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 16,
                            color: auxText,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.calendar_today,
                          color: auxText,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ ГАЛОЧКА "ВСЕ ИГРЫ"
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Все',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: auxText,
                      ),
                    ),
                    Checkbox(
                      value: _showAllMatches,
                      activeColor: accentColor,
                      onChanged: (val) {
                        setState(() {
                          _showAllMatches = val ?? false;
                        });
                        _loadMatchesForDate();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🟢 Выбор вратаря
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: primaryText, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _goalkeepers.isEmpty
                          ? const Text('Нет вратарей', style: TextStyle(fontFamily: 'Unbounded', fontSize: 16, color: auxText))
                          : DropdownButtonHideUnderline(
                        child: DropdownButton<Goalkeeper>(
                          isExpanded: true,
                          value: _selectedGoalkeeper,
                          style: const TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.bold, color: primaryText),
                          icon: const Icon(Icons.arrow_drop_down, color: accentColor),
                          items: _goalkeepers.map((keeper) {
                            return DropdownMenuItem<Goalkeeper>(
                              value: keeper,
                              child: Text('${keeper.firstName} ${keeper.lastName}', overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (Goalkeeper? newValue) async {
                            setState(() {
                              _selectedGoalkeeper = newValue;
                            });
                            await _loadMatchesForDate();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                        : 'Нет игр за ${dateFormat.format(_selectedDate)}',
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
                // Внутри ListView.builder -> itemBuilder

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                    // ✅ ИЗМЕНЕНИЕ: Иконка теперь кликабельна
                    leading: InkWell(
                      onTap: () => _navigateToGoalList(match),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF3AAE9F),
                          size: 26,
                        ),
                      ),
                    ),

                    title: Text(
                      'ИГРА С ${match.opponent.toUpperCase()}',
                      style: const TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF121212)),
                    ),
                    subtitle: Text(
                      '${DateFormat('dd.MM.yyyy').format(match.date)} | Счёт: ${match.score ?? "0:0"}',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        color: Color(0xFF9B9EA1),
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') _deleteMatch(match);
                        else if (value == 'edit') _editMatch(match);
                        else if (value == 'goals') _navigateToGoalList(match);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                        const PopupMenuItem(value: 'goals', child: Text('Указать голы')),
                        const PopupMenuItem(value: 'delete', child: Text('Удалить', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 16),
        child: FloatingActionButton.extended(
          onPressed: _showAddMatchDialog,
          backgroundColor: darkButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          label: const Text(
            'ДОБАВИТЬ ИГРУ',
            style: TextStyle(fontFamily: 'Unbounded', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}