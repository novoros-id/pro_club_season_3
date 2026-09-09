import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';
import 'goal_input_wizard.dart';

class GoalListScreen extends ConsumerStatefulWidget {
  final Matche match;
  final String hand; // Хват вратаря ('left' или 'right')

  const GoalListScreen({
    super.key,
    required this.match,
    this.hand = 'right',
  });

  @override
  ConsumerState<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends ConsumerState<GoalListScreen> {
  List<Goal> _goals = [];
  bool _isLoading = true;
  bool _isAddButtonPressed = false;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121A1F);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color borderGrey = Color(0xFFD8DADF);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color darkButton = Color(0xFF121A1F);
  static const Color softLime = Color(0x26BBF246); // lime 15%

  static const double borderRadius = 15.0;

  // Единый стиль всплывающих меню — как в DiaryMainScreen
  static const Color popupMenuBg = Color(0xFFF2F2F7);
  static const double popupMenuRadius = 15.0;
  static const double popupMenuItemHeight = 52.0;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  ThemeData _screenTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: accentColor,
        onPrimary: primaryText,
        secondary: accentColor,
        onSecondary: primaryText,
        surface: Colors.white,
        onSurface: primaryText,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor,
      ),
    );
  }

  Future<void> _loadGoals() async {
    final db = ref.read(databaseProvider);
    final goals = await db.getGoalsByMatch(widget.match.id);

    if (!mounted) return;

    setState(() {
      _goals = goals;
      _isLoading = false;
    });
  }

  Future<void> _addGoal() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInputWizard(
          match: widget.match,
          hand: widget.hand,
        ),
      ),
    );

    if (result == true) {
      await _loadGoals();
    }
  }

  Future<void> _editGoal(Goal goal) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => GoalInputWizard(
          match: widget.match,
          existingGoal: goal,
          hand: widget.hand,
        ),
      ),
    );

    if (result == true) {
      await _loadGoals();
    }
  }

  Future<void> _deleteGoal(Goal goal) async {
    final db = ref.read(databaseProvider);
    await db.deleteGoal(goal.id);
    await _loadGoals();
  }

  String _getGoalTypeName(int typeId) {
    const types = {
      1: 'Прямой бросок',
      2: 'Бросок с передачи',
      3: 'Добивание',
      4: 'Закрывание обзора',
      5: 'Подставление',
      6: 'Выход 1 на 1 (буллит)',
      7: 'Атака из-за ворот',
    };

    return types[typeId] ?? 'Неизвестно';
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = MediaQuery.of(context).size.width < 360;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 24 : 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: isSmallScreen ? 64 : 72,
                  height: isSmallScreen ? 64 : 72,
                  decoration: const BoxDecoration(
                    color: softLime,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.sports_hockey,
                    size: isSmallScreen ? 30 : 34,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Голов пока нет',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Добавьте первый пропущенный гол этой игры',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 15,
                    height: 1.4,
                    color: auxText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalCard(Goal goal, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmall = screenWidth < 350;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderGrey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _editGoal(goal),
          borderRadius: BorderRadius.circular(16),
          splashColor: softLime,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(isVerySmall ? 12 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: isVerySmall ? 42 : 48,
                  height: isVerySmall ? 42 : 48,
                  decoration: BoxDecoration(
                    color: softLime,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: isVerySmall ? 16 : 18,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                ),
                SizedBox(width: isVerySmall ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGoalTypeName(goal.goalTypeId),
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: isVerySmall ? 13 : 15,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                          height: 1.25,
                        ),
                      ),
                      if (_hasText(goal.fromZone) || _hasText(goal.zone))
                        const SizedBox(height: 10),
                      if (_hasText(goal.fromZone))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 17,
                                  color: primaryText,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Откуда: ${goal.fromZone}',
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: primaryText,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_hasText(goal.zone))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                Icons.adjust,
                                size: 17,
                                color: primaryText,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Куда: ${goal.zone}',
                                softWrap: true,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: primaryText,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(width: isVerySmall ? 6 : 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderGrey),
                  ),
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    tooltip: 'Действия с голом',
                    position: PopupMenuPosition.under,
                    offset: const Offset(0, 22),
                    color: popupMenuBg,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.black12,
                    elevation: 8,
                    icon: const Icon(
                      Icons.more_vert,
                      color: primaryText,
                      size: 22,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(popupMenuRadius),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editGoal(goal);
                      } else if (value == 'delete') {
                        _deleteGoal(goal);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
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
                                  fontSize: 15,
                                  color: primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
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
                                  fontSize: 15,
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
          ),
        ),
      ),
    );
  }

  Widget _buildAddGoalButton() {
    return SizedBox(
      width: double.infinity,
      child: Semantics(
        button: true,
        label: 'Добавить гол',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            setState(() {
              _isAddButtonPressed = true;
            });
          },
          onTapCancel: () {
            if (!mounted) return;
            setState(() {
              _isAddButtonPressed = false;
            });
          },
          onTapUp: (_) {
            if (!mounted) return;
            setState(() {
              _isAddButtonPressed = false;
            });
          },
          onTap: () async {
            await _addGoal();

            if (!mounted) return;

            setState(() {
              _isAddButtonPressed = false;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: _isAddButtonPressed ? accentColor : darkButton,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.add,
                  size: 22,
                  color: _isAddButtonPressed ? primaryText : Colors.white,
                ),
                const SizedBox(width: 9),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Добавить гол',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isAddButtonPressed
                            ? primaryText
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            icon: const Icon(
              Icons.arrow_back,
              color: primaryText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Пропущенные голы',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Игра с ${widget.match.opponent}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: auxText,
                  ),
                ),
              ],
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
              child: _goals.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  16,
                ),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  return _buildGoalCard(_goals[index], index);
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
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
                  child: _buildAddGoalButton(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
