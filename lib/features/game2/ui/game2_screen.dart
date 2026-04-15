import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/game2_controller.dart';

class Game2Screen extends ConsumerWidget {
  const Game2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.game2Title), leading: BackButton()),
      body: Center(child: Text(l10n.game2Title, style: Theme.of(context).textTheme.headlineSmall)),
    );
  }
}