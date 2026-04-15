import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider = NotifierProvider<HomeController, void>(HomeController.new);

class HomeController extends Notifier<void> {
  @override
  void build() {}
// Навигация обрабатывается в UI через context.push
}