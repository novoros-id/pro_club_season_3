import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart'; // Импорт провайдеров настроек

class AudioService {
  final AudioPlayer _hitPlayer = AudioPlayer();
  final AudioPlayer _goalPlayer = AudioPlayer();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // Предзагрузка звуков для мгновенного воспроизведения
    await _hitPlayer.setSource(AssetSource('audio/hit.mp3'));
    await _goalPlayer.setSource(AssetSource('audio/goal.mp3'));

    _isInitialized = true;
  }

  // Метод для воспроизведения звука с учетом настроек
  Future<void> playSound(AudioPlayer player, Ref ref) async {
    // Проверяем, включен ли звук вообще
    final soundEnabled = ref.read(soundEnabledProvider);
    if (!soundEnabled) return;

    // Получаем текущую громкость
    final volume = ref.read(volumeProvider);

    // Устанавливаем громкость перед воспроизведением
    await player.setVolume(volume);

    // Воспроизводим с начала (чтобы можно было быстро нажимать)
    await player.resume();
    // Если нужно, чтобы звук накладывался сам на себя при быстрых ударах,
    // лучше использовать player.play(...) каждый раз, но resume быстрее для частых событий.
    // Для надежности частых ударов лучше так:
    await player.stop();
    await player.setVolume(volume);
    await player.resume();
  }

  void playHit(Ref ref) {
    if (!_isInitialized) return;
    playSound(_hitPlayer, ref);
  }

  void playGoal(Ref ref) {
    if (!_isInitialized) return;
    playSound(_goalPlayer, ref);
  }

  void dispose() {
    _hitPlayer.dispose();
    _goalPlayer.dispose();
  }
}

// Провайдер для доступа к сервису из любого места
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  // Инициализируем асинхронно при первом обращении
  service.init();
  return service;
});