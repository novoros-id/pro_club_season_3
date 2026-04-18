// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
// Обратите внимание: здесь НЕ нужен import flutter_riverpod, если мы не создаем Provider внутри этого файла через ref.
// Но так как мы создаем глобальную переменную Provider, нам нужно импортировать riverpod ЗДЕСЬ тоже!
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  static StorageService? _instance;
  SharedPreferences? _prefs;

  StorageService._();

  factory StorageService() {
    _instance ??= StorageService._();
    return _instance!;
  }

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized.');
    }
    return _prefs!;
  }

  Future<T?> get<T>(String key) async => prefs.get(key) as T?;
  Future<void> setString(String key, String value) => prefs.setString(key, value);
  Future<void> setBool(String key, bool value) => prefs.setBool(key, value);
  Future<void> setInt(String key, int value) => prefs.setInt(key, value);
  Future<void> setDouble(String key, double value) => prefs.setDouble(key, value);
}

// ✅ ВОТ ЭТА СТРОКА ДОЛЖНА БЫТЬ РАСКОММЕНТИРОВАНА И НАЗЫВАТЬСЯ ИМЕННО ТАК:
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());