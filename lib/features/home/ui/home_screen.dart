import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Цвета из гайда
    const Color darkBg = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);
    const Color fieldBg = Color(0xFFF2F2F7);
    const Color textColor = Color(0xFF121212);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. Баннер с картинкой (БЕЗ надписи) ---
            Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/goalkeeper_banner.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  // Градиент оставил, чтобы картинка красиво переходила в белый фон
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4), // Чуть светлее, так как текста нет
                        ],
                      ),
                    ),
                  ),
                  // ✅ УДАЛИЛ БЛОК С ТЕКСТОМ "Тренировка Вратарей"
                ],
              ),
            ),

            // --- 2. Основной контент (Скроллящийся) ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок с украшалкой ПОД ним
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.mainMenuTitle,
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 60,
                          height: 6,
                          color: accentGreen,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Сетка основных кнопок
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: [
                        _StandardButton(
                          title: l10n.diaryTitle,
                          onPressed: () => context.push('/diary'),
                        ),
                        _StandardButton(
                          title: l10n.analyticsTitle,
                          onPressed: () => context.push('/analytics'),
                        ),
                        _StandardButton(
                          title: l10n.goalkeepersTitle,
                          onPressed: () => context.push('/registration'),
                        ),
                        _StandardButton(
                          title: l10n.aeroHockeyTitle,
                          onPressed: () => context.push('/game2'),
                        ),
                        _StandardButton(
                          title: l10n.schulteTableTitle,
                          onPressed: () => context.push('/game_schulte'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- 3. Нижняя панель (Компактная) ---
            _BottomBar(
              settingsTitle: l10n.settingsTitle,
              authorsTitle: l10n.authorsTitle,
              onSettings: () => context.push('/settings'),
              onAuthors: () => context.push('/authors'),
            ),
          ],
        ),
      ),
    );
  }
}

// Виджет стандартной кнопки (Серая с лаймовой обводкой)
class _StandardButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _StandardButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentGreen = Color(0xFFBBF246);
    const Color fieldBg = Color(0xFFF2F2F7);
    const Color textColor = Color(0xFF121212);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: accentGreen, width: 1.5),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            textAlign: TextAlign.center,
            // ✅ ИЗМЕНЕНИЕ: Убрал FontWeight.bold
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 16,
              fontWeight: FontWeight.normal, // <-- Обычный вес шрифта
              color: textColor,
            ),
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
  final VoidCallback onSettings;
  final VoidCallback onAuthors;

  const _BottomBar({
    required this.settingsTitle,
    required this.authorsTitle,
    required this.onSettings,
    required this.onAuthors,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);

    return Container(
      width: double.infinity,
      // Внешние отступы вокруг всей панели
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Container(
        // Внутренний отступ черной капсулы (создает рамку вокруг кнопок)
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: darkBg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            // ✅ ДОБАВЛЕН ОТСТУП СЛЕВА
            const SizedBox(width: 8),

            Expanded(
              child: _InnerButton(
                title: settingsTitle,
                onPressed: onSettings,
                bgColor: accentGreen,
                textColor: darkBg,
              ),
            ),

            // ✅ РАССТОЯНИЕ МЕЖДУ КНОПКАМИ
            const SizedBox(width: 12),

            Expanded(
              child: _InnerButton(
                title: authorsTitle,
                onPressed: onAuthors,
                bgColor: accentGreen,
                textColor: darkBg,
              ),
            ),

            // ✅ ДОБАВЛЕН ОТСТУП СПРАВА
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// Внутренняя зеленая кнопка
class _InnerButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;

  const _InnerButton({
    required this.title,
    required this.onPressed,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          // ✅ УМЕНЬШЕНА ВЫСОТА (было 8, стало 6)
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            // ✅ УМЕНЬШЕН ШРИФТ (было 11, стало 10)
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
