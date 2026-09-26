import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'; // Для чтения assets
import 'dart:convert'; // Для декодирования JSON
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/sync_provider.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../registration/logic/goalkeepers_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const Color darkBg = Color(0xFF121212);
  static const Color accentGreen = Color(0xFFBBF246);
  static const Color fieldBg = Color(0xFFF2F2F7);
  static const Color textColor = Color(0xFF121212);
  static const Color secondaryText = Color(0xFF9B9EA1);

  final GlobalKey _exportButtonKey = GlobalKey();

  // --- ЛОГИКА ЭКСПОРТА/ИМПОРТА (без изменений) ---
  Future<void> _onExportPressed() async {
    final db = ref.read(databaseProvider);
    final syncService = ref.read(syncServiceProvider);
    final keepers = await db.getAllGoalkeepers();

    if (keepers.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Нет сохраненных вратарей')));
      return;
    }

    final selectedKeeper = await showDialog<Goalkeeper>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Выберите вратаря', style: TextStyle(fontFamily: 'Unbounded', fontWeight: FontWeight.bold, color: darkBg)),
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
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
      try {
        final filePath = await syncService.exportData(selectedKeeper.id);
        if (filePath != null && mounted) {
          Navigator.pop(context);
          final RenderBox? box = _exportButtonKey.currentContext?.findRenderObject() as RenderBox?;
          Rect? sharePositionOrigin;
          if (box != null) {
            final offset = box.localToGlobal(Offset.zero);
            sharePositionOrigin = Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);
          }
          await Share.shareXFiles([XFile(filePath)], text: 'Резервная копия данных вратаря ${selectedKeeper.firstName}', sharePositionOrigin: sharePositionOrigin);
        } else {
          if (mounted) Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red));
        }
      }
    }
  }

  Future<void> _onImportPressed() async {
    final syncService = ref.read(syncServiceProvider);
    final goalkeepersNotifier = ref.read(goalkeepersControllerProvider.notifier);
    if (!mounted) return;
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    try {
      await syncService.importData();
      if (mounted) {
        Navigator.pop(context);
        await goalkeepersNotifier.refresh();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Данные успешно загружены!'), backgroundColor: darkBg));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка импорта: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // --- НОВАЯ ЛОГИКА: ЧТЕНИЕ JSON И ПОКАЗ СПРАВКИ ---

  // Показывает легенду зон вратаря (shots_zones.json)
  Future<void> _showZoneLegend() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/shots_zones.json');
      final List<dynamic> data = json.decode(jsonString);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('ЛЕГЕНДА ЗОН ВРАТАРЯ', style: const TextStyle(fontFamily: 'Unbounded', fontSize: 18, fontWeight: FontWeight.bold, color: darkBg)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // ✅ ЕДИНЫЙ СТИЛЬ: Черный фон, белый текст, подписи Левша/Правша
                              _buildCodeBadge('Левша:', item['код_левша']),
                              const SizedBox(width: 8),
                              _buildCodeBadge('Правша:', item['код_правша']),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(item['описание'] ?? '', style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: textColor, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint("Ошибка загрузки легенды зон: $e");
    }
  }

  // Показывает легенду площадки (shot_sources.json)
  Future<void> _showRinkLegend() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/shot_sources.json');
      final List<dynamic> data = json.decode(jsonString);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('ЛЕГЕНДА ПЛОЩАДКИ', style: const TextStyle(fontFamily: 'Unbounded', fontSize: 18, fontWeight: FontWeight.bold, color: darkBg)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ ЕДИНЫЙ СТИЛЬ: Черный фон для кода площадки
                          _buildCodeBadge('Код:', item['код']),
                          const SizedBox(height: 8),
                          Text(item['описание'] ?? '', style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: textColor)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint("Ошибка загрузки легенды площадки: $e");
    }
  }

  // ✅ УНИФИЦИРОВАННЫЙ ВИДЖЕТ БЕЙДЖА
  // label: "Левша:", "Правша:" или "Код:"
  // code: сам код зоны (A1, J1 и т.д.)
  Widget _buildCodeBadge(String label, String code) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: secondaryText),
        children: [
          TextSpan(text: '$label '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: darkBg, // ✅ ВСЕГДА ЧЕРНЫЙ ФОН
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code ?? '-',
                style: const TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 12,
                  color: Colors.white, // ✅ БЕЛЫЙ ТЕКСТ
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: darkBg), onPressed: () => Navigator.pop(context)),
        title: Text(l10n.settingsTitle.toUpperCase(), style: const TextStyle(fontFamily: 'Unbounded', fontSize: 20, fontWeight: FontWeight.bold, color: darkBg)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // --- УПРАВЛЕНИЕ ДАННЫМИ ---
          const Padding(padding: EdgeInsets.only(left: 8, bottom: 12), child: Text('УПРАВЛЕНИЕ ДАННЫМИ', style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.bold, color: secondaryText, letterSpacing: 1))),

          InkWell(onTap: _onExportPressed, borderRadius: BorderRadius.circular(15), child: Container(key: _exportButtonKey, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(15), border: Border.all(color: accentGreen.withValues(alpha: 0.3))), child: Row(children: [const Icon(Icons.upload_file_outlined, color: darkBg, size: 24), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Выгрузить данные', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: textColor)), const SizedBox(height: 4), Text('Сохранить резервную копию', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: secondaryText))])), const Icon(Icons.keyboard_arrow_right, color: darkBg)]))),
          const SizedBox(height: 16),

          InkWell(onTap: _onImportPressed, borderRadius: BorderRadius.circular(15), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(15), border: Border.all(color: accentGreen.withValues(alpha: 0.3))), child: Row(children: [const Icon(Icons.download_for_offline_outlined, color: darkBg, size: 24), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Загрузить данные', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: textColor)), const SizedBox(height: 4), Text('Восстановить из файла', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: secondaryText))])), const Icon(Icons.keyboard_arrow_right, color: darkBg)]))),

          const SizedBox(height: 32),

          // --- СПРАВКА / ЛЕГЕНДЫ ---
          const Padding(padding: EdgeInsets.only(left: 8, bottom: 12), child: Text('СПРАВКА', style: TextStyle(fontFamily: 'Unbounded', fontSize: 14, fontWeight: FontWeight.bold, color: secondaryText, letterSpacing: 1))),

          InkWell(onTap: _showZoneLegend, borderRadius: BorderRadius.circular(15), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(15), border: Border.all(color: accentGreen.withValues(alpha: 0.3))), child: Row(children: [const Icon(Icons.grid_on, color: darkBg, size: 24), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Легенда зон', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: textColor)), const SizedBox(height: 4), Text('Зоны вратаря (A1-P2)', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: secondaryText))])), const Icon(Icons.keyboard_arrow_right, color: darkBg)]))),
          const SizedBox(height: 16),

          InkWell(onTap: _showRinkLegend, borderRadius: BorderRadius.circular(15), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: fieldBg, borderRadius: BorderRadius.circular(15), border: Border.all(color: accentGreen.withValues(alpha: 0.3))), child: Row(children: [const Icon(Icons.sports_hockey, color: darkBg, size: 24), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Легенда площадки', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.bold, color: textColor)), const SizedBox(height: 4), Text('Зоны бросков (A1-D2)', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: secondaryText))])), const Icon(Icons.keyboard_arrow_right, color: darkBg)]))),
        ],
      ),
    );
  }
}