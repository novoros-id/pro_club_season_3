// lib/core/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ✅ УБРАЛИ импорт storage_service — он не нужен здесь

// Тема
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Язык
final localeProvider = StateProvider<Locale>((ref) => const Locale('ru'));

// Звук
final soundEnabledProvider = StateProvider<bool>((ref) => true);
final volumeProvider = StateProvider<double>((ref) => 0.8);

// ✅ УБРАЛИ settingsSyncProvider — синхронизацию сделаем позже
// Когда почините окружение, можно будет вернуть полноценную синхронизацию