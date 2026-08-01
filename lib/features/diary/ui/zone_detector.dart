import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ZoneDetector {
  // Карта соответствия цветов зонам
  static final Map<int, String> _colorToZone = {
    0xFF0000FF: 'A1',   // Красный
    0x00FF00FF: 'A2',   // Зеленый
    0x0000FFFF: 'A3',   // Синий
    0xFFFF00FF: 'A4',   // Желтый
    0xFF00FFFF: 'A5',   // Маджента
    0x00FFFFFF: 'B1',   // Циан
    0x800000FF: 'B2',   // Темно-красный
    0x008000FF: 'B3',   // Темно-зеленый
    0x000080FF: 'B4',   // Темно-синий
    0x808000FF: 'B5',   // Оливковый
    0x800080FF: 'B6',   // Пурпурный
    0x008080FF: 'B7',   // Бирюзовый
    0xFFA500FF: 'B8',   // Оранжевый
    0xA52A2AFF: 'B9',   // Коричневый
    0x7FFF00FF: 'C1',   // Салатовый
    0xDC143CFF: 'C2',   // Малиновый
    0x4169E1FF: 'C3',   // Королевский синий
    0xFF1493FF: 'C4',   // Розовый
    0x2E8B57FF: 'C5',   // Морская волна
    0xFFD700FF: 'D1',   // Золотой
    0x4B0082FF: 'D2',   // Индиго
  };

  static img.Image? _zoneImage;
  static bool _isLoaded = false;

  // ✅ ДОБАВИТЬ ЭТОТ МЕТОД:
  static String? getDebugColorCode(double normalizedX, double normalizedY) {
    if (_zoneImage == null) return null;

    final pixelX = (normalizedX * _zoneImage!.width).round();
    final pixelY = (normalizedY * _zoneImage!.height).round();

    if (pixelX < 0 || pixelX >= _zoneImage!.width ||
        pixelY < 0 || pixelY >= _zoneImage!.height) {
      return null;
    }

    final pixel = _zoneImage!.getPixel(pixelX, pixelY);
    final color = (pixel.r.toInt() << 24) |
    (pixel.g.toInt() << 16) |
    (pixel.b.toInt() << 8) |
    pixel.a.toInt();

    return '0x${color.toRadixString(16).padLeft(8, '0')}';
  }

  // Загрузка карты зон
  static Future<void> loadZoneMap() async {
    if (_isLoaded) return;

    try {
      final ByteData data = await rootBundle.load('assets/images/zones.png');
      final Uint8List bytes = data.buffer.asUint8List();
      _zoneImage = img.decodeImage(bytes);
      _isLoaded = true;
      print('✅ Карта зон загружена: ${_zoneImage!.width}x${_zoneImage!.height}');
    } catch (e) {
      print('❌ Ошибка загрузки карты зон: $e');
    }
  }

  // Определение зоны по нормализованным координатам
  static String? getZone(double normalizedX, double normalizedY) {
    if (_zoneImage == null) {
      print('⚠️ Карта зон не загружена');
      return null;
    }

    // Конвертируем нормализованные координаты в пиксели
    final int pixelX = (normalizedX * _zoneImage!.width).round();
    final int pixelY = (normalizedY * _zoneImage!.height).round();

    // Проверка границ
    if (pixelX < 0 || pixelX >= _zoneImage!.width ||
        pixelY < 0 || pixelY >= _zoneImage!.height) {
      return null;
    }

    // Получаем цвет пикселя
    final pixel = _zoneImage!.getPixel(pixelX, pixelY);

    // ✅ ИСПРАВЛЕНО: используем правильное получение цвета
    final color = (pixel.r.toInt() << 24) |
    (pixel.g.toInt() << 16) |
    (pixel.b.toInt() << 8) |
    pixel.a.toInt();

    // Ищем зону в карте
    return _colorToZone[color];
  }
}