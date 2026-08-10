import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

const Color _darkBg = Color(0xFF121A1F);
const Color _accentGreen = Color(0xFFBBF246);
const Color _fieldBg = Color(0xFFF2F2F7);
const Color _borderGrey = Color(0xFFD8DADF);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _HeaderImage(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: l10n.mainMenuTitle),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 138,
                            child: _MenuCard(
                              title: l10n.diaryTitle,
                              iconAsset: 'assets/images/diary.svg',
                              backgroundColor: _darkBg,
                              contentColor: Colors.white,
                              iconColor: _accentGreen,
                              iconBackgroundColor:
                              const Color(0xFF263129),
                              isLarge: true,
                              preserveColorsOnPress: true,
                              onPressed: () => context.push('/diary'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 138,
                            child: _MenuCard(
                              title: l10n.analyticsTitle,
                              iconAsset: 'assets/images/analytics.svg',
                              backgroundColor: _accentGreen,
                              contentColor: _darkBg,
                              iconColor: _darkBg,
                              iconBackgroundColor:
                              const Color(0x99FFFFFF),
                              isLarge: true,
                              onPressed: () => context.push('/analytics'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 118,
                            child: _MenuCard(
                              title: l10n.goalkeepersTitle,
                              iconAsset:
                              'assets/images/goalkeepers.svg',
                              onPressed: () =>
                                  context.push('/registration'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 118,
                            child: _MenuCard(
                              title: l10n.dailyTasksTitle,
                              iconAsset:
                              'assets/images/daily_tasks.svg',
                              onPressed: () =>
                                  context.push('/daily-tasks'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 118,
                            child: _MenuCard(
                              title: l10n.aeroHockeyTitle,
                              iconAsset:
                              'assets/images/air_hockey.svg',
                              onPressed: () => context.push('/game2'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 118,
                            child: _MenuCard(
                              title: l10n.schulteTableTitle,
                              iconAsset:
                              'assets/images/schulte.svg',
                              onPressed: () =>
                                  context.push('/game_schulte'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            _BottomBar(
              settingsTitle: l10n.settingsTitle,
              authorsTitle: l10n.authorsTitle,
              onSettings: () async {
                await context.push('/settings');
              },
              onAuthors: () async {
                await context.push('/authors');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  const _HeaderImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/caver.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.50, 0.90, 1.0],
                colors: [
                  Colors.transparent,
                  Color(0x33FFFFFF),
                  Colors.white,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(
          left: -5,
          bottom: 2,
          child: ColoredBox(
            color: _accentGreen,
            child: SizedBox(
              width: 65,
              height: 8,
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            height: 1.15,
            color: _darkBg,
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatefulWidget {
  final String title;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color contentColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool isLarge;
  final bool preserveColorsOnPress;

  const _MenuCard({
    required this.title,
    required this.onPressed,
    this.icon,
    this.iconAsset,
    this.backgroundColor = _fieldBg,
    this.contentColor = _darkBg,
    this.iconColor = _darkBg,
    this.iconBackgroundColor = Colors.white,
    this.isLarge = false,
    this.preserveColorsOnPress = false,
  })  : assert(icon != null || iconAsset != null),
        assert(icon == null || iconAsset == null);

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usePressedColors =
        _isPressed && !widget.preserveColorsOnPress;

    final backgroundColor = usePressedColors
        ? _accentGreen
        : widget.backgroundColor;

    final contentColor = usePressedColors
        ? _darkBg
        : widget.contentColor;

    final iconColor = usePressedColors
        ? _darkBg
        : widget.iconColor;

    final iconBackgroundColor = usePressedColors
        ? const Color(0x99FFFFFF)
        : widget.iconBackgroundColor;

    final borderColor = usePressedColors
        ? _accentGreen
        : widget.backgroundColor == _fieldBg
        ? _borderGrey
        : widget.backgroundColor;

    return Semantics(
      button: true,
      label: widget.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(
              widget.isLarge ? 16 : 13,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: 1.3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: widget.isLarge ? 46 : 42,
                  height: widget.isLarge ? 46 : 42,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: contentColor.withValues(alpha: 0.10),
                      width: 1.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: widget.iconAsset != null
                      ? SvgPicture.asset(
                    widget.iconAsset!,
                    width: widget.isLarge ? 28 : 25,
                    height: widget.isLarge ? 28 : 25,
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                  )
                      : Icon(
                    widget.icon,
                    size: widget.isLarge ? 28 : 25,
                    color: iconColor,
                  ),
                ),
                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _BottomBarItem {
  settings,
  authors,
}

class _BottomBar extends StatefulWidget {
  final String settingsTitle;
  final String authorsTitle;
  final Future<void> Function() onSettings;
  final Future<void> Function() onAuthors;

  const _BottomBar({
    required this.settingsTitle,
    required this.authorsTitle,
    required this.onSettings,
    required this.onAuthors,
  });

  @override
  State<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<_BottomBar> {
  _BottomBarItem? _pressedItem;

  void _startPress(_BottomBarItem item) {
    if (_pressedItem == item) {
      return;
    }

    setState(() {
      _pressedItem = item;
    });
  }

  void _cancelPress(_BottomBarItem item) {
    if (_pressedItem != item) {
      return;
    }

    setState(() {
      _pressedItem = null;
    });
  }

  Future<void> _openItem(
      _BottomBarItem item,
      Future<void> Function() onPressed,
      ) async {
    _startPress(item);

    try {
      await onPressed();
    } finally {
      if (mounted) {
        setState(() {
          _pressedItem = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _darkBg,
          borderRadius: BorderRadius.circular(32),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const dividerWidth = 1.0;

            final actionsWidth =
                constraints.maxWidth - dividerWidth;

            final selectedWidth = actionsWidth * 0.54;
            final regularWidth = actionsWidth * 0.50;
            final reducedWidth = actionsWidth - selectedWidth;

            final settingsWidth = switch (_pressedItem) {
              _BottomBarItem.settings => selectedWidth,
              _BottomBarItem.authors => reducedWidth,
              null => regularWidth,
            };

            final authorsWidth =
                actionsWidth - settingsWidth;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: settingsWidth,
                  child: _BottomAction(
                    title: widget.settingsTitle,
                    iconAsset: 'assets/images/settings.svg',
                    isPressed:
                    _pressedItem == _BottomBarItem.settings,
                    onPressStart: () {
                      _startPress(_BottomBarItem.settings);
                    },
                    onPressCancel: () {
                      _cancelPress(_BottomBarItem.settings);
                    },
                    onPressed: () async {
                      await _openItem(
                        _BottomBarItem.settings,
                        widget.onSettings,
                      );
                    },
                  ),
                ),

                Align(
                  child: Container(
                    width: dividerWidth,
                    height: 30,
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: authorsWidth,
                  child: _BottomAction(
                    title: widget.authorsTitle,
                    iconAsset: 'assets/images/author.svg',
                    isPressed:
                    _pressedItem == _BottomBarItem.authors,
                    onPressStart: () {
                      _startPress(_BottomBarItem.authors);
                    },
                    onPressCancel: () {
                      _cancelPress(_BottomBarItem.authors);
                    },
                    onPressed: () async {
                      await _openItem(
                        _BottomBarItem.authors,
                        widget.onAuthors,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Future<void> Function() onPressed;
  final VoidCallback onPressStart;
  final VoidCallback onPressCancel;
  final bool isPressed;

  const _BottomAction({
    required this.title,
    required this.iconAsset,
    required this.onPressed,
    required this.onPressStart,
    required this.onPressCancel,
    required this.isPressed,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor =
    isPressed ? _darkBg : Colors.white;

    return Semantics(
      button: true,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          onPressStart();
        },
        onTapCancel: onPressCancel,
        onTap: () async {
          await onPressed();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isPressed
                ? _accentGreen
                : Colors.transparent,
            borderRadius: BorderRadius.circular(27),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 21,
                height: 21,
                colorFilter: ColorFilter.mode(
                  isPressed ? _darkBg : _accentGreen,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: contentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}