import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import 'dart:developer' as developer; // Для логов

class AudioService {
  final AudioPlayer _hitPlayer = AudioPlayer();
  final AudioPlayer _goalPlayer = AudioPlayer();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      developer.log('🔊 Initializing audio...');
      await _hitPlayer.setSource(AssetSource('audio/hit.mp3'));
      await _goalPlayer.setSource(AssetSource('audio/goal.mp3'));
      _isInitialized = true;
      developer.log('✅ Audio initialized successfully');
    } catch (e) {
      developer.log('❌ Error initializing audio: $e');
    }
  }

  Future<void> playSound(AudioPlayer player, Ref ref) async {
    if (!_isInitialized) {
      developer.log('⚠️ Audio not initialized yet');
      return;
    }

    final soundEnabled = ref.read(soundEnabledProvider);
    if (!soundEnabled) {
      developer.log('🔇 Sound is disabled in settings');
      return;
    }

    final volume = ref.read(volumeProvider);
    developer.log('🔊 Playing sound with volume: $volume');

    try {
      await player.setVolume(volume);
      await player.stop(); // Останавливаем предыдущее воспроизведение
      await player.resume(); // Запускаем заново
    } catch (e) {
      developer.log('❌ Error playing sound: $e');
    }
  }

  void playHit(Ref ref) => playSound(_hitPlayer, ref);
  void playGoal(Ref ref) => playSound(_goalPlayer, ref);

  void dispose() {
    _hitPlayer.dispose();
    _goalPlayer.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  service.init(); // Инициализация при создании провайдера
  return service;
});