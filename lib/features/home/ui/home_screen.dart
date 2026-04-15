import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final routes = [
      ('/registration', l10n.registrationTitle),
      ('/settings', l10n.settingsTitle),
      ('/diary', l10n.diaryTitle),
      ('/game1', l10n.game1Title),
      ('/game2', l10n.game2Title),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: routes.map((r) {
            final (path, title) = r;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () => context.push(path),
                child: Text(title),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}