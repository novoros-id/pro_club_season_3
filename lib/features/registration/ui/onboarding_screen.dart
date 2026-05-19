import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Цвета из гайда
    const Color darkBg = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);
    const Color textGrey = Color(0xFF9B9EA1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Картинка вратаря (замени путь на свой актуальный)
                  Image.asset(
                    'assets/images/goalkeeper_banner.png',
                    fit: BoxFit.cover,
                  ),
                  // Затемнение снизу
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appName.toUpperCase(), // "ТРЕНИРОВКА ВРАТАРЕЙ"
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Понимай, почему тебе забивают\nи становись сильнее с каждой игрой',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Акцентная полоска
                    Container(
                      width: 40,
                      height: 4,
                      color: accentGreen,
                      margin: const EdgeInsets.only(bottom: 32),
                    ),

                    // Кнопка "Давай начнем"
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.push('/add-goalkeeper'), // Переход к форме
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Полностью круглая
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'ДАВАЙ НАЧНЁМ',
                          style: const TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}