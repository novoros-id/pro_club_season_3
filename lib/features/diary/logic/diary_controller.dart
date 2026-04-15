import 'package:flutter_riverpod/flutter_riverpod.dart';

final diaryControllerProvider = NotifierProvider<DiaryController, void>(DiaryController.new);

class DiaryController extends Notifier<void> {
  @override void build() {}
// Здесь будет логика загрузки/сохранения записей дневника
}