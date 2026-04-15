// lib/features/settings/logic/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/settings_provider.dart';
// ✅ УБРАЛИ: import '../../../core/services/storage_service.dart';

final settingsControllerProvider = Provider<SettingsController>((ref) => SettingsController(ref));

class SettingsController {
  final Ref ref;
  SettingsController(this.ref);

  void toggleTheme(bool isDark) {
    ref.read(themeModeProvider.notifier).state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleSound(bool enabled) => ref.read(soundEnabledProvider.notifier).state = enabled;
  void setSound(bool enabled) => ref.read(soundEnabledProvider.notifier).state = enabled;
  void setVolume(double vol) => ref.read(volumeProvider.notifier).state = vol;
  void setLanguage(String code) => ref.read(localeProvider.notifier).state = Locale(code);

  // ✅ Методы сохранения в SharedPreferences — заглушки на потом
  // В реальном проекте здесь будет: await storageService.setBool('sound', enabled);
  Future<void> saveSettings() async {
    // TODO: реализовать сохранение, когда починим зависимости
  }
}