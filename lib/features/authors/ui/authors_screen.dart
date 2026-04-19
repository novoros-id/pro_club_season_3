import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart'; // Пакет для открытия ссылок
import '../../../l10n/app_localizations.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  // Функция для открытия URL
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.authorsTitle),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Блок клуба разработчиков
            _SectionTitle(title: l10n.developersClub),
            const SizedBox(height: 8),
            _LinkText(
              text: '1cproconsulting.ru',
              url: 'https://1cproconsulting.ru/',
              onLaunch: _launchUrl,
            ),

            const Divider(height: 32),

            // Блок методики
            _SectionTitle(title: l10n.methodologyAuthor),
            const SizedBox(height: 8),
            _LinkText(
              text: 'antonshustov.ru',
              url: 'https://www.antonshustov.ru/',
              onLaunch: _launchUrl,
            ),

            const Divider(height: 32),

            // Список авторов
            _SectionTitle(title: l10n.programAuthors),
            const SizedBox(height: 16),

            _AuthorItem(name: 'Иван Василишин', email: 'ivan.vasilishin@1cproconsulting.ru'),
            _AuthorItem(name: 'Дмитрий Гришаев', email: 'dmitriy.grishaev@1cproconsulting.ru'),
            _AuthorItem(name: 'Екатерина Еськова', email: 'ekaterina.eskova@1cproconsulting.ru'),
            _AuthorItem(name: 'Эльвина Тазиева', email: 'elvina.tazieva@1cproconsulting.ru'),
            _AuthorItem(name: 'Алексей Ваганов', email: 'aleksei.vaganov@1cproconsulting.ru'), // Исправил опечатку в email

          ],
        ),
      ),
    );
  }
}

// Виджет заголовка раздела
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.blue[900],
      ),
    );
  }
}

// Виджет ссылки
class _LinkText extends StatelessWidget {
  final String text;
  final String url;
  final Function(String) onLaunch;

  const _LinkText({required this.text, required this.url, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onLaunch(url),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue[700],
          decoration: TextDecoration.underline,
          fontSize: 16,
        ),
      ),
    );
  }
}

// Виджет автора с email
class _AuthorItem extends StatelessWidget {
  final String name;
  final String email;

  const _AuthorItem({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('● ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                InkWell(
                  onTap: () async {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: email,
                    );
                    if (!await launchUrl(emailUri)) {
                      throw Exception('Could not launch $emailUri');
                    }
                  },
                  child: Text(
                    email,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
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