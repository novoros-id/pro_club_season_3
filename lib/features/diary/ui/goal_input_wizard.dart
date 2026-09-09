import 'dart:math' as math;

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import 'zone_detector.dart';

class GoalInputWizard extends ConsumerStatefulWidget {
  final Matche match;
  final Goal? existingGoal;
  final String hand; // 'left' или 'right'

  const GoalInputWizard({
    super.key,
    required this.match,
    this.existingGoal,
    this.hand = 'right',
  });

  @override
  ConsumerState<GoalInputWizard> createState() =>
      _GoalInputWizardState();
}

class _GoalInputWizardState
    extends ConsumerState<GoalInputWizard> {
  final GlobalKey _rinkContainerKey = GlobalKey();
  final GlobalKey _imageContainerKey = GlobalKey();

  int _currentStep = 0;
  int _selectedGoalTypeId = 1;

  double? _toZoneX;
  double? _toZoneY;

  double? _fromZoneX;
  double? _fromZoneY;

  String? _currentZone;
  String? _fromZone;

  String? _debugColorCode;

  bool _showDebugGrid = false;
  bool _showFromZoneGrid = false;

  // ─────────────────────────────────────────────────────────────
  // ДИЗАЙН-СИСТЕМА
  // ─────────────────────────────────────────────────────────────

  static const Color primaryText = Color(0xFF121A1F);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color inputBg = Color(0xFFF2F2F7);
  static const Color borderGrey = Color(0xFFD8DADF);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color darkButton = Color(0xFF121A1F);

  // Lime 15%
  static const Color softLime = Color(0x26BBF246);

  static const double borderRadius = 15.0;

  // Пропорции картинки вратаря 947 × 720
  static const double goalieAspectRatio = 720 / 947;

  // Пропорции изображения площадки
  static const double rinkAspectRatio = 1097 / 1055;

  final List<Map<String, dynamic>> _goalTypes = [
    {
      'id': 1,
      'name': 'Прямой бросок',
    },
    {
      'id': 2,
      'name': 'Бросок с передачи',
    },
    {
      'id': 3,
      'name': 'Добивание',
    },
    {
      'id': 4,
      'name': 'Закрывание обзора',
    },
    {
      'id': 5,
      'name': 'Подставление',
    },
    {
      'id': 6,
      'name': 'Выход 1 на 1 (буллит)',
    },
    {
      'id': 7,
      'name': 'Атака из-за ворот',
    },
  ];

  // ─────────────────────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    ZoneDetector.loadZoneMap();

    if (widget.existingGoal != null) {
      _selectedGoalTypeId =
          widget.existingGoal!.goalTypeId;

      _toZoneX =
          widget.existingGoal!.toZoneX;

      _toZoneY =
          widget.existingGoal!.toZoneY;

      _fromZoneX =
          widget.existingGoal!.fromZoneX;

      _fromZoneY =
          widget.existingGoal!.fromZoneY;

      _currentZone =
          widget.existingGoal!.zone;

      _fromZone =
          widget.existingGoal!.fromZone;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // ТЕМА
  // ─────────────────────────────────────────────────────────────

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
      progressIndicatorTheme:
      const ProgressIndicatorThemeData(
        color: accentColor,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // НАВИГАЦИЯ ПО ШАГАМ
  // ─────────────────────────────────────────────────────────────

  void _nextStep() {
    if (_currentStep == 0) {
      setState(() {
        _currentStep =
        _selectedGoalTypeId == 1
            ? 1
            : 2;

        // Для типов, кроме прямого броска,
        // точка попадания в ворота не используется.
        if (_selectedGoalTypeId != 1) {
          _toZoneX = null;
          _toZoneY = null;
          _currentZone = null;
        }
      });

      return;
    }

    if (_currentStep == 1) {
      setState(() {
        _currentStep = 2;
      });

      return;
    }

    _saveGoal();
  }

  void _previousStep() {
    if (_currentStep == 2) {
      setState(() {
        _currentStep =
        _selectedGoalTypeId == 1
            ? 1
            : 0;
      });

      return;
    }

    if (_currentStep == 1) {
      setState(() {
        _currentStep = 0;
      });

      return;
    }

    Navigator.pop(context);
  }

  // ─────────────────────────────────────────────────────────────
  // СОХРАНЕНИЕ
  // ─────────────────────────────────────────────────────────────

  Future<void> _saveGoal() async {
    final db = ref.read(databaseProvider);

    if (widget.existingGoal != null) {
      final updated = Goal(
        id: widget.existingGoal!.id,
        matchId: widget.match.id,
        goalTypeId: _selectedGoalTypeId,
        toZoneX: _toZoneX,
        toZoneY: _toZoneY,
        fromZoneX: _fromZoneX,
        fromZoneY: _fromZoneY,
        zone: _currentZone,
        fromZone: _fromZone,
        createdAt:
        widget.existingGoal!.createdAt,
      );

      await db.updateGoal(updated);
    } else {
      await db.insertGoal(
        GoalsCompanion.insert(
          matchId: widget.match.id,
          goalTypeId: _selectedGoalTypeId,
          toZoneX: Value(_toZoneX),
          toZoneY: Value(_toZoneY),
          fromZoneX: Value(_fromZoneX),
          fromZoneY: Value(_fromZoneY),
          zone: Value(_currentZone),
          fromZone: Value(_fromZone),
        ),
      );
    }

    if (mounted) {
      Navigator.pop(
        context,
        true,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // РАСЧЁТ ЗОНЫ ВОРОТ
  // ─────────────────────────────────────────────────────────────

  String? _calculateZone(
      double normalizedX,
      double normalizedY,
      double width,
      double height,
      double centerX,
      double centerY,
      double maxRadius,
      double innerRadius,
      ) {
    final double px =
        normalizedX * width;

    final double py =
        normalizedY * height;

    final double dx =
        px - centerX;

    final double dy =
        py - centerY;

    final double dist =
    math.sqrt(
      dx * dx + dy * dy,
    );

    if (dist > maxRadius) {
      return null;
    }

    final String ring =
    dist < innerRadius
        ? '2'
        : '1';

    double angleRad =
    math.atan2(
      dx,
      -dy,
    );

    double angleDeg =
        angleRad *
            180 /
            math.pi;

    if (angleDeg < 0) {
      angleDeg += 360;
    }

    const List<String> sectors = [
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'A',
      'B',
      'C',
      'D',
      'E',
    ];

    int sectorIndex =
    (angleDeg / 22.5).floor();

    if (sectorIndex >=
        sectors.length) {
      sectorIndex = 0;
    }

    return '${sectors[sectorIndex]}$ring';
  }

  // ─────────────────────────────────────────────────────────────
  // ТЕКУЩИЙ ВИЗУАЛЬНЫЙ ШАГ
  // ─────────────────────────────────────────────────────────────

  int get _visualStep {
    if (_selectedGoalTypeId == 1) {
      return _currentStep + 1;
    }

    return _currentStep == 0
        ? 1
        : 2;
  }

  int get _totalSteps =>
      _selectedGoalTypeId == 1
          ? 3
          : 2;

  bool get _isLastStep =>
      _currentStep == 2;

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(
      BuildContext context,
      ) {
    final double screenWidth =
        MediaQuery.of(context)
            .size
            .width;

    final double horizontalPadding =
    screenWidth < 360
        ? 12
        : 16;

    return Theme(
      data: _screenTheme(context),
      child: Scaffold(
        backgroundColor:
        Colors.white,

        // ─────────────────────────────
        // APP BAR
        // ─────────────────────────────

        appBar: AppBar(
          backgroundColor:
          Colors.white,
          surfaceTintColor:
          Colors.transparent,
          elevation: 0,

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: primaryText,
            ),
            onPressed:
            _previousStep,
          ),

          titleSpacing: 0,

          title: Padding(
            padding:
            const EdgeInsets.only(
              right: 16,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisSize:
              MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment:
                  Alignment.centerLeft,
                  child: Text(
                    widget.existingGoal !=
                        null
                        ? 'Редактировать гол'
                        : 'Новый гол',
                    maxLines: 1,
                    style:
                    const TextStyle(
                      fontFamily:
                      'Unbounded',
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      primaryText,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Игра с ${widget.match.opponent}',
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w500,
                    color: auxText,
                  ),
                ),
              ],
            ),
          ),
        ),

        body: SafeArea(
          top: false,
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 680,
              ),
              child: Column(
                children: [
                  // ─────────────────────
                  // ШАГИ
                  // ─────────────────────

                  Padding(
                    padding:
                    EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      14,
                    ),
                    child:
                    _buildProgress(),
                  ),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color:
                    Color(0xFFEEEEEE),
                  ),

                  // ─────────────────────
                  // СОДЕРЖИМОЕ
                  // ─────────────────────

                  Expanded(
                    child:
                    _buildCurrentStep(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ─────────────────────────────
        // НИЖНИЕ КНОПКИ
        // ─────────────────────────────

        bottomNavigationBar:
        DecoratedBox(
          decoration:
          const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding:
              EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                12,
              ),
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints:
                  const BoxConstraints(
                    maxWidth: 648,
                  ),
                  child:
                  _buildBottomButtons(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ПРОГРЕСС
  // ─────────────────────────────────────────────────────────────

  Widget _buildProgress() {
    if (_selectedGoalTypeId == 1) {
      return Row(
        children: [
          _buildStepIndicator(
            step: 1,
            label: 'Тип',
          ),

          Expanded(
            child:
            _buildStepLine(
              completed:
              _visualStep >= 2,
            ),
          ),

          _buildStepIndicator(
            step: 2,
            label: 'Куда',
          ),

          Expanded(
            child:
            _buildStepLine(
              completed:
              _visualStep >= 3,
            ),
          ),

          _buildStepIndicator(
            step: 3,
            label: 'Откуда',
          ),
        ],
      );
    }

    return Row(
      children: [
        _buildStepIndicator(
          step: 1,
          label: 'Тип',
        ),

        Expanded(
          child: _buildStepLine(
            completed:
            _visualStep >= 2,
          ),
        ),

        _buildStepIndicator(
          step: 2,
          label: 'Откуда',
        ),
      ],
    );
  }

  Widget _buildStepLine({
    required bool completed,
  }) {
    return Container(
      height: 2,
      margin:
      const EdgeInsets.only(
        left: 6,
        right: 6,
        bottom: 22,
      ),
      decoration: BoxDecoration(
        color: completed
            ? accentColor
            : borderGrey,
        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),
    );
  }

  Widget _buildStepIndicator({
    required int step,
    required String label,
  }) {
    final bool completed =
        step < _visualStep;

    final bool current =
        step == _visualStep;

    final bool active =
        step <= _visualStep;

    return SizedBox(
      width: 66,
      child: Column(
        children: [
          AnimatedContainer(
            duration:
            const Duration(
              milliseconds: 150,
            ),
            width: 40,
            height: 40,
            decoration:
            BoxDecoration(
              color: current
                  ? accentColor
                  : completed
                  ? softLime
                  : inputBg,
              shape:
              BoxShape.circle,
              border: Border.all(
                color: active
                    ? accentColor
                    : borderGrey,
                width:
                current
                    ? 0
                    : 1,
              ),
            ),
            alignment:
            Alignment.center,
            child: completed
                ? const Icon(
              Icons.check,
              size: 19,
              color:
              primaryText,
            )
                : Text(
              '$step',
              style:
              TextStyle(
                fontFamily:
                'Unbounded',
                fontSize: 13,
                fontWeight:
                FontWeight
                    .w700,
                color: current
                    ? primaryText
                    : auxText,
              ),
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          FittedBox(
            fit:
            BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style:
              TextStyle(
                fontFamily:
                'Unbounded',
                fontSize: 10,
                fontWeight:
                active
                    ? FontWeight
                    .w600
                    : FontWeight
                    .w500,
                color: active
                    ? primaryText
                    : auxText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ТЕКУЩИЙ ШАГ
  // ─────────────────────────────────────────────────────────────

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildGoalTypeStep();

      case 1:
        return _buildToZoneStep();

      case 2:
        return _buildFromZoneStep();

      default:
        return const SizedBox();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // ШАГ 1 — ТИП ГОЛА
  // ─────────────────────────────────────────────────────────────

  Widget _buildGoalTypeStep() {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final double padding =
        constraints.maxWidth <
            360
            ? 12
            : 16;

        return ListView.builder(
          padding:
          EdgeInsets.fromLTRB(
            padding,
            16,
            padding,
            24,
          ),
          itemCount:
          _goalTypes.length,
          itemBuilder:
              (context, index) {
            final goalType =
            _goalTypes[index];

            final int id =
            goalType['id']
            as int;

            final bool isSelected =
                _selectedGoalTypeId ==
                    id;

            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 10,
              ),
              child: Material(
                color:
                Colors.transparent,
                borderRadius:
                BorderRadius.circular(
                  borderRadius,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedGoalTypeId =
                          id;
                    });
                  },
                  borderRadius:
                  BorderRadius.circular(
                    borderRadius,
                  ),
                  splashColor:
                  softLime,
                  highlightColor:
                  Colors.transparent,
                  child:
                  AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 120,
                    ),
                    constraints:
                    const BoxConstraints(
                      minHeight: 62,
                    ),
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration:
                    BoxDecoration(
                      color: isSelected
                          ? softLime
                          : inputBg,
                      borderRadius:
                      BorderRadius
                          .circular(
                        borderRadius,
                      ),
                      border:
                      Border.all(
                        color: isSelected
                            ? const Color(
                          0x66BBF246,
                        )
                            : borderGrey,
                        width:
                        isSelected
                            ? 1.4
                            : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration:
                          BoxDecoration(
                            color:
                            isSelected
                                ? accentColor
                                : Colors
                                .white,
                            shape:
                            BoxShape
                                .circle,
                            border:
                            Border.all(
                              color:
                              isSelected
                                  ? accentColor
                                  : borderGrey,
                            ),
                          ),
                          alignment:
                          Alignment
                              .center,
                          child: Text(
                            '$id',
                            style:
                            const TextStyle(
                              fontFamily:
                              'Unbounded',
                              fontSize: 13,
                              fontWeight:
                              FontWeight
                                  .w700,
                              color:
                              primaryText,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 14,
                        ),

                        Expanded(
                          child: Text(
                            goalType[
                            'name']
                            as String,
                            softWrap:
                            true,
                            style:
                            const TextStyle(
                              fontFamily:
                              'Unbounded',
                              fontSize: 14,
                              fontWeight:
                              FontWeight
                                  .w600,
                              color:
                              primaryText,
                              height: 1.3,
                            ),
                          ),
                        ),

                        if (isSelected) ...[
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.check,
                            color:
                            primaryText,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ШАГ 2 — КУДА ЗАБИТ ГОЛ
  // ─────────────────────────────────────────────────────────────

  Widget _buildToZoneStep() {
    final String goalieImage =
    widget.hand == 'left'
        ? 'assets/images/goalie_l.png'
        : 'assets/images/goalie_r.png';

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final double screenPadding =
        constraints.maxWidth <
            360
            ? 12
            : 16;

        final double availableWidth =
            constraints.maxWidth -
                screenPadding * 2;

        final double containerWidth =
        math.min(
          availableWidth,
          620,
        );

        final double containerHeight =
            containerWidth *
                goalieAspectRatio;

        final double centerX =
            containerWidth / 2;

        final double centerY =
            containerHeight / 2 +
                containerHeight *
                    0.085;

        final double outerRadius =
            containerWidth * 0.51;

        final double innerRadius =
            containerWidth * 0.35;

        return SingleChildScrollView(
          padding:
          EdgeInsets.fromLTRB(
            screenPadding,
            16,
            screenPadding,
            24,
          ),
          child: Column(
            children: [
              _buildStepHeader(
                title:
                'Отметь, куда забит гол',
                subtitle:
                'Нажми на ворота',
                gridEnabled:
                _showDebugGrid,
                onGridPressed: () {
                  setState(() {
                    _showDebugGrid =
                    !_showDebugGrid;
                  });
                },
              ),

              const SizedBox(
                height: 14,
              ),

              Center(
                child:
                GestureDetector(
                  behavior:
                  HitTestBehavior
                      .opaque,
                  onTapDown:
                      (details) {
                    final RenderBox?
                    box =
                    _imageContainerKey
                        .currentContext
                        ?.findRenderObject()
                    as RenderBox?;

                    if (box ==
                        null) {
                      return;
                    }

                    final Offset
                    containerOffset =
                    box.localToGlobal(
                      Offset.zero,
                    );

                    final double
                    relativeX =
                        details
                            .globalPosition
                            .dx -
                            containerOffset
                                .dx;

                    final double
                    relativeY =
                        details
                            .globalPosition
                            .dy -
                            containerOffset
                                .dy;

                    final double
                    normalizedX =
                        relativeX /
                            box.size
                                .width;

                    final double
                    normalizedY =
                        relativeY /
                            box.size
                                .height;

                    if (normalizedX >=
                        0 &&
                        normalizedX <=
                            1 &&
                        normalizedY >=
                            0 &&
                        normalizedY <=
                            1) {
                      setState(() {
                        _toZoneX =
                            normalizedX;

                        _toZoneY =
                            normalizedY;

                        _currentZone =
                            _calculateZone(
                              normalizedX,
                              normalizedY,
                              box.size
                                  .width,
                              box.size
                                  .height,
                              box.size
                                  .width /
                                  2,
                              box.size
                                  .height /
                                  2 +
                                  box.size
                                      .height *
                                      0.085,
                              box.size
                                  .width *
                                  0.51,
                              box.size
                                  .width *
                                  0.35,
                            );
                      });
                    }
                  },
                  child: Container(
                    key:
                    _imageContainerKey,
                    width:
                    containerWidth,
                    height:
                    containerHeight,
                    decoration:
                    BoxDecoration(
                      color: inputBg,
                      borderRadius:
                      BorderRadius
                          .circular(
                        borderRadius,
                      ),
                      border:
                      Border.all(
                        color:
                        borderGrey,
                      ),
                    ),
                    clipBehavior:
                    Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child:
                          Image.asset(
                            goalieImage,
                            fit:
                            BoxFit
                                .contain,
                            alignment:
                            Alignment
                                .bottomCenter,
                          ),
                        ),

                        if (_showDebugGrid)
                          Positioned.fill(
                            child:
                            CustomPaint(
                              painter:
                              ZoneGridPainter(
                                width:
                                containerWidth,
                                height:
                                containerHeight,
                                centerX:
                                centerX,
                                centerY:
                                centerY,
                                innerRadius:
                                innerRadius,
                                outerRadius:
                                outerRadius,
                              ),
                            ),
                          ),

                        if (_toZoneX !=
                            null &&
                            _toZoneY !=
                                null)
                          Positioned(
                            left: _toZoneX! *
                                containerWidth -
                                14,
                            top: _toZoneY! *
                                containerHeight -
                                14,
                            child:
                            Container(
                              width: 28,
                              height: 28,
                              decoration:
                              BoxDecoration(
                                color:
                                accentColor,
                                shape:
                                BoxShape
                                    .circle,
                                border:
                                Border.all(
                                  color:
                                  Colors
                                      .white,
                                  width: 2,
                                ),
                                boxShadow:
                                const [
                                  BoxShadow(
                                    color:
                                    Colors
                                        .black26,
                                    blurRadius:
                                    5,
                                    offset:
                                    Offset(
                                      0,
                                      2,
                                    ),
                                  ),
                                ],
                              ),
                              child:
                              const Icon(
                                Icons
                                    .sports_hockey,
                                color:
                                primaryText,
                                size: 16,
                              ),
                            ),
                          ),

                        if (_currentZone !=
                            null &&
                            _toZoneX !=
                                null &&
                            _toZoneY !=
                                null)
                          Positioned(
                            left: _toZoneX! *
                                containerWidth -
                                22,
                            top: _toZoneY! *
                                containerHeight +
                                20,
                            child:
                            _buildZoneLabel(
                              _currentZone!,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              _buildInfoBox(
                'Сюда отмечай только чистые прямые броски: '
                    'ты успел занять позицию, видел шайбу и весь её полёт, '
                    'тебе никто не мешал. Получаем информацию по реакции, '
                    'если есть время на реагирование, и расположению по глубине. '
                    'Если бросок совсем близко и времени на реакцию нет — '
                    'ставь точку в тот сектор ворот, куда зашла шайба.',
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ШАГ 3 — ОТКУДА БЫЛ БРОСОК
  // ─────────────────────────────────────────────────────────────

  Widget _buildFromZoneStep() {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final double screenPadding =
        constraints.maxWidth <
            360
            ? 12
            : 16;

        final double availableWidth =
            constraints.maxWidth -
                screenPadding * 2;

        final double containerWidth =
        math.min(
          availableWidth,
          620,
        );

        final double containerHeight =
            containerWidth *
                rinkAspectRatio;

        return SingleChildScrollView(
          padding:
          EdgeInsets.fromLTRB(
            screenPadding,
            16,
            screenPadding,
            24,
          ),
          child: Column(
            children: [
              _buildStepHeader(
                title:
                'Отметь, откуда был бросок',
                subtitle:
                'Нажми на площадку',
                gridEnabled:
                _showFromZoneGrid,
                onGridPressed: () {
                  setState(() {
                    _showFromZoneGrid =
                    !_showFromZoneGrid;
                  });
                },
              ),

              const SizedBox(
                height: 14,
              ),

              Center(
                child:
                GestureDetector(
                  behavior:
                  HitTestBehavior
                      .opaque,
                  onTapDown:
                      (details) {
                    final RenderBox?
                    box =
                    _rinkContainerKey
                        .currentContext
                        ?.findRenderObject()
                    as RenderBox?;

                    if (box ==
                        null) {
                      return;
                    }

                    final Offset
                    containerOffset =
                    box.localToGlobal(
                      Offset.zero,
                    );

                    final double
                    relativeX =
                        details
                            .globalPosition
                            .dx -
                            containerOffset
                                .dx;

                    final double
                    relativeY =
                        details
                            .globalPosition
                            .dy -
                            containerOffset
                                .dy;

                    final double
                    normalizedX =
                        relativeX /
                            box.size
                                .width;

                    final double
                    normalizedY =
                        relativeY /
                            box.size
                                .height;

                    if (normalizedX >=
                        0 &&
                        normalizedX <=
                            1 &&
                        normalizedY >=
                            0 &&
                        normalizedY <=
                            1) {
                      setState(() {
                        _fromZoneX =
                            normalizedX;

                        _fromZoneY =
                            normalizedY;

                        _fromZone =
                            ZoneDetector
                                .getZone(
                              normalizedX,
                              normalizedY,
                            );

                        _debugColorCode =
                            ZoneDetector
                                .getDebugColorCode(
                              normalizedX,
                              normalizedY,
                            );
                      });
                    }
                  },
                  child: Container(
                    key:
                    _rinkContainerKey,
                    width:
                    containerWidth,
                    height:
                    containerHeight,
                    decoration:
                    BoxDecoration(
                      color: inputBg,
                      borderRadius:
                      BorderRadius
                          .circular(
                        borderRadius,
                      ),
                      border:
                      Border.all(
                        color:
                        borderGrey,
                      ),
                    ),
                    clipBehavior:
                    Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child:
                          Image.asset(
                            _showFromZoneGrid
                                ? 'assets/images/pole_zones.png'
                                : 'assets/images/pole.png',
                            fit:
                            BoxFit
                                .contain,
                            alignment:
                            Alignment
                                .center,
                          ),
                        ),

                        if (_fromZoneX !=
                            null &&
                            _fromZoneY !=
                                null)
                          Positioned(
                            left: _fromZoneX! *
                                containerWidth -
                                14,
                            top: _fromZoneY! *
                                containerHeight -
                                14,
                            child:
                            Container(
                              width: 28,
                              height: 28,
                              decoration:
                              BoxDecoration(
                                color:
                                accentColor,
                                shape:
                                BoxShape
                                    .circle,
                                border:
                                Border.all(
                                  color:
                                  Colors
                                      .white,
                                  width: 2,
                                ),
                                boxShadow:
                                const [
                                  BoxShadow(
                                    color:
                                    Colors
                                        .black26,
                                    blurRadius:
                                    5,
                                    offset:
                                    Offset(
                                      0,
                                      2,
                                    ),
                                  ),
                                ],
                              ),
                              child:
                              const Icon(
                                Icons
                                    .location_on,
                                color:
                                primaryText,
                                size: 17,
                              ),
                            ),
                          ),

                        if (_fromZone !=
                            null &&
                            _fromZoneX !=
                                null &&
                            _fromZoneY !=
                                null)
                          Positioned(
                            left: _fromZoneX! *
                                containerWidth -
                                22,
                            top: _fromZoneY! *
                                containerHeight +
                                20,
                            child:
                            _buildZoneLabel(
                              _fromZone!,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              _buildInfoBox(
                'Здесь отмечаешь место, откуда пробили или забили гол '
                    '(на нашей половине площадки).',
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ЗАГОЛОВОК ШАГА
  // ─────────────────────────────────────────────────────────────

  Widget _buildStepHeader({
    required String title,
    required String subtitle,
    required bool gridEnabled,
    required VoidCallback onGridPressed,
  }) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        14,
        12,
        10,
        12,
      ),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius:
        BorderRadius.circular(
          borderRadius,
        ),
        border: Border.all(
          color: borderGrey,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: true,
                  style:
                  const TextStyle(
                    fontFamily:
                    'Unbounded',
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    primaryText,
                    height: 1.3,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  subtitle,
                  style:
                  const TextStyle(
                    fontFamily:
                    'Lato',
                    fontSize: 13,
                    color: auxText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Material(
            color: gridEnabled
                ? accentColor
                : Colors.white,
            borderRadius:
            BorderRadius.circular(
              12,
            ),
            child: InkWell(
              onTap:
              onGridPressed,
              borderRadius:
              BorderRadius.circular(
                12,
              ),
              child: Container(
                width: 44,
                height: 44,
                decoration:
                BoxDecoration(
                  borderRadius:
                  BorderRadius
                      .circular(
                    12,
                  ),
                  border:
                  Border.all(
                    color: gridEnabled
                        ? accentColor
                        : borderGrey,
                  ),
                ),
                alignment:
                Alignment.center,
                child: Icon(
                  gridEnabled
                      ? Icons.grid_on
                      : Icons.grid_off,
                  color: gridEnabled
                      ? primaryText
                      : auxText,
                  size: 21,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ИНФОРМАЦИОННЫЙ БЛОК
  // ─────────────────────────────────────────────────────────────

  Widget _buildInfoBox(
      String text,
      ) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(
        14,
      ),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius:
        BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: Text(
        text,
        textAlign:
        TextAlign.left,
        style:
        const TextStyle(
          fontFamily: 'Lato',
          fontSize: 14,
          height: 1.45,
          color: auxText,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ПЛАШКА ЗОНЫ
  // ─────────────────────────────────────────────────────────────

  Widget _buildZoneLabel(
      String zone,
      ) {
    return Container(
      constraints:
      const BoxConstraints(
        minWidth: 42,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: darkButton,
        borderRadius:
        BorderRadius.circular(
          10,
        ),
      ),
      child: Text(
        zone,
        textAlign:
        TextAlign.center,
        style:
        const TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 11,
          fontWeight:
          FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // НИЖНИЕ КНОПКИ
  // ─────────────────────────────────────────────────────────────

  Widget _buildBottomButtons() {
    final bool hasBackButton =
        _currentStep > 0;

    return Row(
      children: [
        if (hasBackButton) ...[
          Expanded(
            child:
            _buildBackButton(),
          ),

          const SizedBox(
            width: 10,
          ),
        ],

        Expanded(
          flex:
          hasBackButton
              ? 2
              : 1,
          child:
          _buildNextButton(),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return OutlinedButton(
      onPressed:
      _previousStep,
      style: ButtonStyle(
        minimumSize:
        const WidgetStatePropertyAll<
            Size>(
          Size(
            double.infinity,
            56,
          ),
        ),
        padding:
        const WidgetStatePropertyAll<
            EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        shape:
        const WidgetStatePropertyAll<
            OutlinedBorder>(
          StadiumBorder(),
        ),
        side:
        const WidgetStatePropertyAll<
            BorderSide>(
          BorderSide(
            color: borderGrey,
            width: 1.2,
          ),
        ),
        backgroundColor:
        WidgetStateProperty.resolveWith<
            Color?>(
              (states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return softLime;
            }

            return Colors.white;
          },
        ),
        foregroundColor:
        const WidgetStatePropertyAll<
            Color>(
          primaryText,
        ),
        overlayColor:
        const WidgetStatePropertyAll<
            Color>(
          Colors.transparent,
        ),
      ),
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'Назад',
          maxLines: 1,
          style: TextStyle(
            fontFamily:
            'Unbounded',
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
            color:
            primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed:
      _nextStep,
      style: ButtonStyle(
        minimumSize:
        const WidgetStatePropertyAll<
            Size>(
          Size(
            double.infinity,
            56,
          ),
        ),
        padding:
        const WidgetStatePropertyAll<
            EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevation:
        const WidgetStatePropertyAll<
            double>(
          0,
        ),
        shape:
        const WidgetStatePropertyAll<
            OutlinedBorder>(
          StadiumBorder(),
        ),
        backgroundColor:
        WidgetStateProperty.resolveWith<
            Color>(
              (states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return accentColor;
            }

            return darkButton;
          },
        ),
        foregroundColor:
        WidgetStateProperty.resolveWith<
            Color>(
              (states) {
            if (states.contains(
              WidgetState.pressed,
            )) {
              return primaryText;
            }

            return Colors.white;
          },
        ),
        overlayColor:
        const WidgetStatePropertyAll<
            Color>(
          Colors.transparent,
        ),
      ),
      child: FittedBox(
        fit:
        BoxFit.scaleDown,
        child: Text(
          _isLastStep
              ? 'Готово'
              : 'Далее',
          maxLines: 1,
          style:
          const TextStyle(
            fontFamily:
            'Unbounded',
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ОТЛАДОЧНАЯ СЕТКА ЗОН
// ─────────────────────────────────────────────────────────────

class ZoneGridPainter
    extends CustomPainter {
  final double width;
  final double height;
  final double centerX;
  final double centerY;
  final double innerRadius;
  final double outerRadius;

  ZoneGridPainter({
    required this.width,
    required this.height,
    required this.centerX,
    required this.centerY,
    required this.innerRadius,
    required this.outerRadius,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final linePaint = Paint()
      ..color =
      Colors.red.withOpacity(
        0.7,
      )
      ..strokeWidth = 1.5
      ..style =
          PaintingStyle.stroke;

    final innerCirclePaint =
    Paint()
      ..color =
      Colors.blue
          .withOpacity(
        0.7,
      )
      ..strokeWidth = 1.5
      ..style =
          PaintingStyle
              .stroke;

    final outerCirclePaint =
    Paint()
      ..color =
      Colors.green
          .withOpacity(
        0.7,
      )
      ..strokeWidth = 1.5
      ..style =
          PaintingStyle
              .stroke;

    canvas.drawCircle(
      Offset(
        centerX,
        centerY,
      ),
      outerRadius,
      outerCirclePaint,
    );

    canvas.drawCircle(
      Offset(
        centerX,
        centerY,
      ),
      innerRadius,
      innerCirclePaint,
    );

    final double startAngleRad =
        -math.pi / 2;

    final double stepRad =
        22.5 *
            math.pi /
            180;

    for (int i = 0;
    i < 16;
    i++) {
      final angle =
          startAngleRad +
              i * stepRad;

      final dx =
          math.cos(angle) *
              outerRadius;

      final dy =
          math.sin(angle) *
              outerRadius;

      canvas.drawLine(
        Offset(
          centerX,
          centerY,
        ),
        Offset(
          centerX + dx,
          centerY + dy,
        ),
        linePaint,
      );
    }

    canvas.drawCircle(
      Offset(
        centerX,
        centerY,
      ),
      3,
      Paint()
        ..color =
            Colors.black,
    );

    canvas.drawCircle(
      Offset(
        centerX,
        centerY -
            outerRadius,
      ),
      4,
      Paint()
        ..color =
            Colors.red,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) =>
      false;
}