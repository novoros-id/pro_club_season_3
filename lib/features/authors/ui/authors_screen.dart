import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Цвета из гайда
    const Color darkBg = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);
    const Color fieldBg = Color(0xFFF2F2F7);
    const Color textColor = Color(0xFF121212);
    const Color secondaryText = Color(0xFF9B9EA1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkBg),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.authorsTitle.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkBg,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- КЛУБ РАЗРАБОТЧИКОВ ---
            _SectionHeader(title: l10n.developersClub),
            const SizedBox(height: 12),
            _LinkCard(
              text: '1cproconsulting.ru',
              url: 'https://1cproconsulting.ru/',
              onLaunch: _launchUrl,
            ),

            const SizedBox(height: 32),

            // --- МЕТОДИКА ---
            _SectionHeader(title: l10n.methodologyAuthor),
            const SizedBox(height: 12),
            _LinkCard(
              text: 'antonshustov.ru',
              url: 'https://www.antonshustov.ru/',
              onLaunch: _launchUrl,
            ),

            const SizedBox(height: 32),

            // --- АВТОРЫ ПРОГРАММЫ ---
            _SectionHeader(title: l10n.programAuthors),
            const SizedBox(height: 16),

            _AuthorCard(
              name: 'Иван Василишин',
              email: 'ivan.vasilishin@1cproconsulting.ru',
            ),
            const SizedBox(height: 12),
            _AuthorCard(
              name: 'Екатерина Еськова',
              email: 'ekaterina.eskova@1cproconsulting.ru',
            ),
            const SizedBox(height: 12),
            _AuthorCard(
              name: 'Алексей Ваганов',
              email: 'aleksei.vaganov@1cproconsulting.ru',
            ),
            const SizedBox(height: 12),
            _AuthorCard(
              name: 'Дмитрий Гришаев',
              email: 'dmitriy.grishaev@1cproconsulting.ru',
            ),
          ],
        ),
      ),
    );
  }
}

// Заголовок раздела с лаймовой полоской
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBg,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 4,
          color: accentGreen,
        ),
      ],
    );
  }
}

// Карточка ссылки (для сайтов)
class _LinkCard extends StatelessWidget {
  final String text;
  final String url;
  final Function(String) onLaunch;

  const _LinkCard({
    required this.text,
    required this.url,
    required this.onLaunch,
  });

  @override
  Widget build(BuildContext context) {
    const Color fieldBg = Color(0xFFF2F2F7);
    const Color textColor = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);

    return InkWell(
      onTap: () => onLaunch(url),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: fieldBg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: accentGreen.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const Icon(Icons.open_in_new, size: 18, color: textColor),
          ],
        ),
      ),
    );
  }
}

// Карточка автора
class _AuthorCard extends StatelessWidget {
  final String name;
  final String email;

  const _AuthorCard({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    const Color fieldBg = Color(0xFFF2F2F7);
    const Color textColor = Color(0xFF121212);
    const Color secondaryText = Color(0xFF9B9EA1);
    const Color accentGreen = Color(0xFFBBF246);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentGreen.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Лаймовый буллит
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: accentGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: email,
                    );
                    if (!await launchUrl(emailUri)) {
                      debugPrint('Could not launch mailto: $email');
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.mail_outline, size: 14, color: secondaryText),
                      const SizedBox(width: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          color: secondaryText,
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
    );
  }
}