import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF121A1F);
    const Color accentGreen = Color(0xFFBBF246);
    const Color greyText = Color(0xFF8F9499);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Верхняя картинка
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height * 0.68,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/goalkeeper_banner.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    // Белый fade снизу
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.58, 0.82, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.white70,
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Контент (теперь прокручиваемый)
              Positioned.fill(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView( // ✅ Добавлена прокрутка
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // ✅ Важно для ScrollView
                      children: [
                        SizedBox(height: height * 0.64),

                        const _LogoTitle(),

                        const SizedBox(height: 35),

                        const Text(
                          'Понимай, почему тебе забивают\nи становись сильнее с каждой игрой',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            height: 1.35,
                            color: greyText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 58),

                        // Украшалка-загрузка
                        const _LoadingDecoration(),

                        const SizedBox(height: 50), // Отступ вместо Spacer

                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isButtonPressed = true;
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                _isButtonPressed = false;
                              });
                            },
                            onTap: () {
                              context.push('/add-goalkeeper').then((_) {
                                if (!mounted) return;
                                setState(() {
                                  _isButtonPressed = false;
                                });
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeOut,
                              decoration: BoxDecoration(
                                color: _isButtonPressed ? accentGreen : darkBg,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: _ButtonText(
                                  text: 'Присоединиться',
                                  textColor: _isButtonPressed
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LogoTitle extends StatelessWidget {
  const _LogoTitle();

  @override
  Widget build(BuildContext context) {
    const Color darkText = Color(0xFF121A1F);
    const Color accentGreen = Color(0xFFBBF246);

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -13,
            bottom: 4,
            child: Container(
              width: 85,
              height: 10,
              color: accentGreen,
            ),
          ),
          const Text(
            'ПУТЬ ВРАТАРЯ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: darkText,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonText extends StatelessWidget {
  final String text;
  final Color textColor;

  const _ButtonText({
    required this.text,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}

class _LoadingDecoration extends StatelessWidget {
  const _LoadingDecoration();

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF121A1F);
    const Color accentGreen = Color(0xFFBBF246);

    return Center(
      child: Container(
        width: 70,
        height: 9,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: darkBg,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerLeft,
        child: Container(
          width: 35,
          height: 4,
          decoration: BoxDecoration(
            color: accentGreen,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}