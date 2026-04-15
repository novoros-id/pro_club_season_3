// lib/core/services/storage_service.dart
// ✅ БЕЗ ЗАВИСИМОСТИ ОТ FLUTTER_RIVERPOD — работает всегда
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  SharedPreferences? _prefs;

  // Приватный конструктор + ленивая инициализация
  StorageService._();

  factory StorageService() {
    _instance ??= StorageService._();
    return _instance!;
  }

  // Метод для инициализации (вызовите в main.dart)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call await StorageService().init() in main()');
    }
    return _prefs!;
  }

  // Методы для работы с данными
  Future<T?> get<T>(String key) async => prefs.get(key) as T?;
  Future<void> setString(String key, String value) => prefs.setString(key, value);
  Future<void> setBool(String key, bool value) => prefs.setBool(key, value);
  Future<void> setInt(String key, int value) => prefs.setInt(key, value);
  Future<void> setDouble(String key, double value) => prefs.setDouble(key, value);
}

// ✅ Простая глобальная переменная вместо Provider
// (позже можно заменить на Riverpod Provider, когда почините окружение)
StorageService get storageService => StorageService();