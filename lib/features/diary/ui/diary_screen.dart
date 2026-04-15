import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/diary_controller.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.diaryTitle), leading: BackButton()),
      body: Center(child: Text(l10n.diaryTitle, style: Theme.of(context).textTheme.headlineSmall)),
    );
  }
}