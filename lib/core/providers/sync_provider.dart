import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_provider.dart'; // Путь к твоему провайдеру БД
import '../services/sync_service.dart';     // Путь к сервису, который мы создадим на Шаге 2

// Этот провайдер создает экземпляр SyncService и передает ему базу данных
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref.read(databaseProvider));
});