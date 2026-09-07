import 'package:flutter_test/flutter_test.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/logic/daily_progress_display.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/logic/daily_progress_stage.dart';

void main() {
  group('dailyProgressSegmentFill', () {
    test('supports empty, partial, and full segments', () {
      expect(dailyProgressSegmentFill(progress: 0, segmentIndex: 0), 0);

      expect(dailyProgressSegmentFill(progress: 0.25, segmentIndex: 0), 1);
      expect(dailyProgressSegmentFill(progress: 0.25, segmentIndex: 1), 1);
      expect(dailyProgressSegmentFill(progress: 0.25, segmentIndex: 2), 0.5);
      expect(dailyProgressSegmentFill(progress: 0.25, segmentIndex: 3), 0);

      expect(dailyProgressSegmentFill(progress: 0.625, segmentIndex: 5), 1);
      expect(dailyProgressSegmentFill(progress: 0.625, segmentIndex: 6), 0.25);
      expect(dailyProgressSegmentFill(progress: 0.625, segmentIndex: 7), 0);

      for (var index = 0; index < 10; index++) {
        expect(dailyProgressSegmentFill(progress: 1, segmentIndex: index), 1);
      }
    });
  });

  group('resolveDailyProgressMessageIndex', () {
    test('is stable for the same goalkeeper, date, and stage', () {
      final date = DateTime(2026, 9, 7);
      final first = resolveDailyProgressMessageIndex(
        goalkeeperId: 42,
        date: date,
        stage: DailyProgressStage.percent60,
      );

      expect(
        resolveDailyProgressMessageIndex(
          goalkeeperId: 42,
          date: date,
          stage: DailyProgressStage.percent60,
        ),
        first,
      );
    });

    test('always returns an index from 0 to 2', () {
      for (final stage in DailyProgressStage.values) {
        for (var goalkeeperId = 1; goalkeeperId <= 20; goalkeeperId++) {
          final index = resolveDailyProgressMessageIndex(
            goalkeeperId: goalkeeperId,
            date: DateTime(2026, 9, goalkeeperId),
            stage: stage,
          );
          expect(index, inInclusiveRange(0, 2));
        }
      }
    });
  });
}
