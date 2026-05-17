import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> menuItems = [
      {'path': '/registration', 'titleKey': 'registrationTitle', 'icon': Icons.person_outline},
      {'path': '/diary', 'titleKey': 'diaryTitle', 'icon': Icons.book_outlined},
      {'path': '/analytics', 'titleKey': 'analyticsTitle', 'icon': Icons.analytics_outlined},
      {'path': '/game1', 'titleKey': 'game1Title', 'icon': Icons.flash_on_outlined},
      {'path': '/game2', 'titleKey': 'game2Title', 'icon': Icons.sports_hockey_outlined},
      {'path': '/settings', 'titleKey': 'settingsTitle', 'icon': Icons.settings_outlined},
      {'path': '/authors', 'titleKey': 'authorsTitle', 'icon': Icons.info_outline},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // --- Блок с картинкой и надписью (Фиксированная высота) ---
            Container(
              width: double.infinity,
              height: 320,
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        l10n.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 8,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Прокручиваемая область с кнопками ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    // Если нужно пустое место сверху перед кнопками, раскомментируйте Spacer или SizedBox
                    // const SizedBox(height: 20),

                    ...menuItems.map((item) {
                      final String path = item['path'] as String;
                      final String titleKey = item['titleKey'] as String;

                      String getTitle(String key) {
                        switch (key) {
                          case 'registrationTitle': return l10n.registrationTitle;
                          case 'diaryTitle': return l10n.diaryTitle;
                          case 'analyticsTitle': return l10n.analyticsTitle;
                          case 'game1Title': return l10n.game1Title;
                          case 'game2Title': return l10n.game2Title;
                          case 'settingsTitle': return l10n.settingsTitle;
                          case 'authorsTitle': return l10n.authorsTitle;
                          default: return '';
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MenuButton(
                          title: getTitle(titleKey),
                          icon: item['icon'] as IconData,
                          onPressed: () => context.push(path),
                        ),
                      );
                    }).toList(),
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

class _MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}