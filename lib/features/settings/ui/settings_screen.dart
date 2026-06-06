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
    final themeMode = ref.watch(themeModeProvider);
    final soundEnabled = ref.watch(soundEnabledProvider);
    final volume = ref.watch(volumeProvider);
    final locale = ref.watch(localeProvider);

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settingsTitle.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkBg,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // --- ТЕМА ---
          _SettingsTile(
            icon: Icons.brightness_6_outlined,
            title: themeMode == ThemeMode.light ? l10n.themeLight : l10n.themeDark,
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              activeColor: Colors.white,
              activeTrackColor: accentGreen,
              inactiveThumbColor: secondaryText,
              inactiveTrackColor: fieldBg,
              onChanged: (v) => controller.toggleTheme(v),
            ),
          ),

          const SizedBox(height: 16),

          // --- ЗВУК ---
          _SettingsTile(
            icon: Icons.volume_up_outlined,
            title: l10n.soundEnabled,
            trailing: Switch(
              value: soundEnabled,
              activeColor: Colors.white,
              activeTrackColor: accentGreen,
              inactiveThumbColor: secondaryText,
              inactiveTrackColor: fieldBg,
              onChanged: controller.setSound,
            ),
          ),

          const SizedBox(height: 16),

          // --- ГРОМКОСТЬ ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: accentGreen.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.graphic_eq_outlined, color: darkBg, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      l10n.volume,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: accentGreen,
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbColor: darkBg,
                    overlayColor: accentGreen.withOpacity(0.2),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: volume,
                    onChanged: controller.setVolume,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- ЯЗЫК (BottomSheet) ---
          InkWell(
            onTap: () => _showLanguageSheet(context, ref, controller),
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
                  Icon(Icons.language_outlined, color: darkBg, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.language,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Text(
                    locale.languageCode == 'ru' ? 'Русский' : 'English',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: secondaryText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.keyboard_arrow_down, color: darkBg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, WidgetRef ref, SettingsController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final currentLang = ref.read(localeProvider).languageCode;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ВЫБЕРИТЕ ЯЗЫК',
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121212),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Radio<String>(
                    value: 'ru',
                    groupValue: currentLang,
                    activeColor: const Color(0xFFBBF246),
                    onChanged: (v) {
                      if (v != null) controller.setLanguage(v);
                      Navigator.pop(ctx);
                    },
                  ),
                  title: const Text('Русский', style: TextStyle(fontFamily: 'Lato')),
                  onTap: () {
                    controller.setLanguage('ru');
                    Navigator.pop(ctx);
                  },
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'en',
                    groupValue: currentLang,
                    activeColor: const Color(0xFFBBF246),
                    onChanged: (v) {
                      if (v != null) controller.setLanguage(v);
                      Navigator.pop(ctx);
                    },
                  ),
                  title: const Text('English', style: TextStyle(fontFamily: 'Lato')),
                  onTap: () {
                    controller.setLanguage('en');
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Вспомогательный виджет для плитки настроек
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF121212);
    const Color fieldBg = Color(0xFFF2F2F7);
    const Color textColor = Color(0xFF121212);
    const Color accentGreen = Color(0xFFBBF246);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: darkBg, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}