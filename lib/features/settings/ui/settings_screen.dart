import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import '../logic/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.watch(settingsControllerProvider);
    final theme = ref.watch(themeModeProvider);
    final sound = ref.watch(soundEnabledProvider);
    final vol = ref.watch(volumeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle), leading: BackButton()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.settingsTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text(theme == ThemeMode.light ? l10n.themeLight : l10n.themeDark),
            value: theme == ThemeMode.dark,
            onChanged: (v) => controller.toggleTheme(v),
          ),
          SwitchListTile(
            title: Text(l10n.soundEnabled),
            value: sound,
            onChanged: controller.setSound,
          ),
          ListTile(
            title: Text(l10n.volume),
            subtitle: Slider(value: vol, onChanged: controller.setVolume),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: ref.watch(localeProvider).languageCode,
              items: const [
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (v) => v != null ? controller.setLanguage(v) : null,
            ),
          )
        ],
      ),
    );
  }
}