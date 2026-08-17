import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/providers/sync_provider.dart';
import '../logic/settings_controller.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../registration/logic/goalkeepers_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Выносим цвета сюда, чтобы они были видны во всем классе
  static const Color darkBg = Color(0xFF121212);
  static const Color accentGreen = Color(0xFFBBF246);
  static const Color fieldBg = Color(0xFFF2F2F7);
  static const Color textColor = Color(0xFF121212);
  static const Color secondaryText = Color(0xFF9B9EA1);

  // Ключ для кнопки экспорта, чтобы знать её позицию на экране (для iOS Share Sheet)
  final GlobalKey _exportButtonKey = GlobalKey();

  Future<void> _onExportPressed() async {
    final db = ref.read(databaseProvider);
    final syncService = ref.read(syncServiceProvider);

    final keepers = await db.getAllGoalkeepers();

    if (keepers.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет сохраненных вратарей')),
      );
      return;
    }

    final selectedKeeper = await showDialog<Goalkeeper>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Выберите вратаря',
          style: TextStyle(fontFamily: 'Unbounded', fontWeight: FontWeight.bold, color: darkBg),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: keepers.length,
            itemBuilder: (context, index) {
              final keeper = keepers[index];
              return ListTile(
                title: Text('${keeper.firstName} ${keeper.lastName}', style: const TextStyle(fontFamily: 'Lato')),
                subtitle: Text(keeper.hand == 'left' ? 'Левша' : 'Правша', style: const TextStyle(color: secondaryText)),
                onTap: () => Navigator.pop(context, keeper),
              );
            },
          ),
        ),
      ),
    );

    if (selectedKeeper != null && mounted) {
      // Показываем лоадер
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

      try {
        // 1. Экспортируем данные и получаем путь к файлу
        final filePath = await syncService.exportData(selectedKeeper.id);

        if (filePath != null && mounted) {
          Navigator.pop(context); // Закрываем лоадер

          // 2. Вычисляем позицию кнопки для iOS (sharePositionOrigin)
          final RenderBox? box = _exportButtonKey.currentContext?.findRenderObject() as RenderBox?;
          Rect? sharePositionOrigin;

          if (box != null) {
            final offset = box.localToGlobal(Offset.zero);
            sharePositionOrigin = Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);
          }

          // 3. Шарим файл с указанием позиции (критично для iOS)
          await Share.shareXFiles(
            [XFile(filePath)],
            text: 'Резервная копия данных вратаря ${selectedKeeper.firstName}',
            sharePositionOrigin: sharePositionOrigin,
          );
        } else {
          if (mounted) Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _onImportPressed() async {
    final syncService = ref.read(syncServiceProvider);

    // ✅ ПОЛУЧАЕМ ДОСТУП К КОНТРОЛЛЕРУ ВРАТАРЕЙ
    final goalkeepersNotifier = ref.read(goalkeepersControllerProvider.notifier);

    if (!mounted) return;

    // Показываем лоадер
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      await syncService.importData();

      if (mounted) {
        Navigator.pop(context); // Закрываем лоадер

        // ✅ ВЫЗЫВАЕМ ОБНОВЛЕНИЕ СПИСКА ВРАТАРЕЙ
        await goalkeepersNotifier.refresh();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Данные успешно загружены!'), backgroundColor: darkBg),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка импорта: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.watch(settingsControllerProvider);
    final themeMode = ref.watch(themeModeProvider);

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
          style: const TextStyle(fontFamily: 'Unbounded', fontSize: 20, fontWeight: FontWeight.bold, color: darkBg),
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
              activeThumbColor: Colors.white,
              activeTrackColor: accentGreen.withValues(alpha: 1.0),
              inactiveThumbColor: secondaryText,
              inactiveTrackColor: fieldBg.withValues(alpha: 1.0),
              onChanged: (v) => controller.toggleTheme(v),
            ),
          ),
          const SizedBox(height: 24),

          // --- ЗАГОЛОВОК РАЗДЕЛА ДАННЫХ ---
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              'УПРАВЛЕНИЕ ДАННЫМИ',
              style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.bold, color: secondaryText, letterSpacing: 1),
            ),
          ),

          // --- ВЫГРУЗКА ---
          InkWell(
            onTap: _onExportPressed,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              key: _exportButtonKey, // <--- ВАЖНО: Привязываем ключ здесь
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: accentGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.upload_file_outlined, color: darkBg, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Выгрузить данные', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 4),
                        Text('Сохранить резервную копию', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: secondaryText)),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right, color: darkBg),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- ЗАГРУЗКА ---
          InkWell(
            onTap: _onImportPressed,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: accentGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.download_for_offline_outlined, color: darkBg, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Загрузить данные', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 4),
                        Text('Восстановить из файла', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: secondaryText)),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_right, color: darkBg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Виджет плитки настроек
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  const _SettingsTile({required this.icon, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _SettingsScreenState.fieldBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _SettingsScreenState.accentGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _SettingsScreenState.darkBg, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: _SettingsScreenState.textColor)),
          ),
          trailing,
        ],
      ),
    );
  }
}