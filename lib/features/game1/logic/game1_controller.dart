import 'package:flutter_riverpod/flutter_riverpod.dart';

final game1ControllerProvider = NotifierProvider<Game1Controller, void>(Game1Controller.new);

class Game1Controller extends Notifier<void> {
  @override void build() {}
// Логика игры "Реакция" будет здесь
}