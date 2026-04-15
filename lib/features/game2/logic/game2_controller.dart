import 'package:flutter_riverpod/flutter_riverpod.dart';

final game2ControllerProvider = NotifierProvider<Game2Controller, void>(Game2Controller.new);

class Game2Controller extends Notifier<void> {
  @override void build() {}
// Логика игры "Точность" будет здесь
}