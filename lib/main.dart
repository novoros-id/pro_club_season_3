import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/storage_service.dart'; // Импорт сервиса
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ ПРАВИЛЬНЫЙ ВЫЗОВ ДЛЯ НОВОЙ РЕАЛИЗАЦИИ:
  // Создаем экземпляр через конструктор и инициализируем его
  await StorageService().init();

  runApp(ProviderScope(child: const GoalkeeperApp()));
}