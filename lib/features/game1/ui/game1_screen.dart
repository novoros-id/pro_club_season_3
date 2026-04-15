import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/game1_controller.dart';

class Game1Screen extends ConsumerWidget {
  const Game1Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.game1Title), leading: BackButton()),
      body: Center(child: Text(l10n.game1Title, style: Theme.of(context).textTheme.headlineSmall)),
    );
  }
}