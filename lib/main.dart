import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/storage_service.dart'; // ← импорт
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Инициализируем StorageService ДО запуска приложения
  await storageService.init();

  runApp(ProviderScope(child: const GoalkeeperApp()));
}