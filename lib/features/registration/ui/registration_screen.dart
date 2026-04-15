import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/registration_controller.dart';

class RegistrationScreen extends ConsumerWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.watch(registrationControllerProvider.notifier);
    final state = ref.watch(registrationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registrationTitle), leading: BackButton()),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.registrationTitle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: state.isSaving ? null : () => controller.submit(),
              child: state.isSaving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}