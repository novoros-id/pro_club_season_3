import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            const _GoalkeeperHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MenuTitle(
                      title: l10n.mainMenuTitle,
                    ),

                    const SizedBox(height: 20),

                    // Первая строка — главные разделы
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _MenuCard(
                            title: l10n.diaryTitle,
                            icon: Icons.menu_book_rounded,
                            backgroundColor: _darkBg,
                            contentColor: Colors.white,
                            iconColor: _accentGreen,
                            iconBackgroundColor:
                            const Color(0xFF263129),
                            borderColor: _darkBg,
                            isLarge: true,
                            onPressed: () async {
                              await context.push('/diary');
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _MenuCard(
                            title: l10n.analyticsTitle,
                            icon: Icons.insights_rounded,
                            backgroundColor: _accentGreen,
                            contentColor: _darkBg,
                            iconColor: _darkBg,
                            iconBackgroundColor:
                            const Color(0x99FFFFFF),
                            borderColor: _accentGreen,
                            isLarge: true,
                            onPressed: () async {
                              await context.push('/analytics');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Вторая строка
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _MenuCard(
                            title: l10n.goalkeepersTitle,
                            icon: Icons.shield_outlined,
                            backgroundColor: _fieldBg,
                            contentColor: _darkBg,
                            iconColor: _darkBg,
                            iconBackgroundColor: Colors.white,
                            borderColor: _borderGrey,
                            isLarge: false,
                            onPressed: () async {
                              await context.push('/registration');
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _MenuCard(
                            title: l10n.dailyTasksTitle,
                            icon: Icons.fact_check_outlined,
                            backgroundColor: _fieldBg,
                            contentColor: _darkBg,
                            iconColor: _darkBg,
                            iconBackgroundColor: Colors.white,
                            borderColor: _borderGrey,
                            isLarge: false,
                            onPressed: () async {
                              await context.push('/daily-tasks');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Третья строка
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _MenuCard(
                            title: l10n.aeroHockeyTitle,
                            icon: Icons.sports_hockey,
                            backgroundColor: _fieldBg,
                            contentColor: _darkBg,
                            iconColor: _darkBg,
                            iconBackgroundColor: Colors.white,
                            borderColor: _borderGrey,
                            isLarge: false,
                            onPressed: () async {
                              await context.push('/game2');
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _MenuCard(
                            title: l10n.schulteTableTitle,
                            icon: Icons.grid_view_rounded,
                            backgroundColor: _fieldBg,
                            contentColor: _darkBg,
                            iconColor: _darkBg,
                            iconBackgroundColor: Colors.white,
                            borderColor: _borderGrey,
                            isLarge: false,
                            onPressed: () async {
                              await context.push('/game_schulte');
                            },
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

// Верхняя фотография
class _GoalkeeperHeader extends StatelessWidget {
  const _GoalkeeperHeader();

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

          // Плавный переход фотографии в белый фон
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.50,
                  0.90,
                  1.0,
                ],
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

// Заголовок главного меню
class _MenuTitle extends StatelessWidget {
  final String title;

  const _MenuTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Лаймовая плашка под первой частью заголовка
        Positioned(
          left: -5,
          bottom: 2,
          child: Container(
            width: 65,
            height: 8,
            color: _accentGreen,
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

// Карточка главного меню
class _MenuCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color contentColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color borderColor;
  final bool isLarge;
  final Future<void> Function() onPressed;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.contentColor,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.borderColor,
    required this.isLarge,
    required this.onPressed,
  });

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _isPressed = false;

  Future<void> _handleTap() async {
    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color currentBackground =
    _isPressed ? _accentGreen : widget.backgroundColor;

    final Color currentContent =
    _isPressed ? _darkBg : widget.contentColor;

    final Color currentIcon =
    _isPressed ? _darkBg : widget.iconColor;

    final Color currentBorder =
    _isPressed ? _accentGreen : widget.borderColor;

    final double cardHeight =
    widget.isLarge ? 138 : 118;

    final double iconBoxSize =
    widget.isLarge ? 46 : 42;

    final double iconSize =
    widget.isLarge ? 28 : 25;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          height: cardHeight,
          padding: EdgeInsets.all(
            widget.isLarge ? 16 : 13,
          ),
          decoration: BoxDecoration(
            color: currentBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: currentBorder,
              width: 1.3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: _isPressed
                      ? const Color(0x99FFFFFF)
                      : widget.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: _isPressed
                        ? _darkBg
                        : widget.isLarge
                        ? widget.iconColor
                        : _accentGreen,
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  size: iconSize,
                  color: currentIcon,
                ),
              ),

              const Spacer(),

              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: -0.2,
                  color: currentContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Нижняя панель
class _BottomBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        14,
      ),
      child: Container(
        height: 62,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _darkBg,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            Expanded(
              child: _BottomAction(
                title: settingsTitle,
                icon: Icons.settings_rounded,
                onPressed: onSettings,
              ),
            ),

            Container(
              width: 1,
              height: 30,
              color: const Color(0x33FFFFFF),
            ),

            Expanded(
              child: _BottomAction(
                title: authorsTitle,
                icon: Icons.info_outline_rounded,
                onPressed: onAuthors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Кнопка нижней панели
class _BottomAction extends StatefulWidget {
  final String title;
  final IconData icon;
  final Future<void> Function() onPressed;

  const _BottomAction({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_BottomAction> createState() =>
      _BottomActionState();
}

class _BottomActionState extends State<_BottomAction> {
  bool _isPressed = false;

  Future<void> _handleTap() async {
    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        height: double.infinity,
        decoration: BoxDecoration(
          color: _isPressed
              ? _accentGreen
              : Colors.transparent,
          borderRadius: BorderRadius.circular(27),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 21,
              color: _isPressed
                  ? _darkBg
                  : _accentGreen,
            ),

            const SizedBox(width: 8),

            Flexible(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _isPressed
                      ? _darkBg
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}