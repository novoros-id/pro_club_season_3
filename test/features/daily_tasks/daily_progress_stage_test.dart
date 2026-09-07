import 'package:flutter_test/flutter_test.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/logic/daily_progress_stage.dart';

void main() {
  group('resolveDailyProgressStage', () {
    final cases = <({int completed, int total, DailyProgressStage expected})>[
      (completed: 0, total: 0, expected: DailyProgressStage.noTasks),
      (completed: 0, total: 8, expected: DailyProgressStage.percent0),
      (completed: 1, total: 8, expected: DailyProgressStage.percent20),
      (completed: 3, total: 8, expected: DailyProgressStage.percent20),
      (completed: 4, total: 10, expected: DailyProgressStage.percent40),
      (completed: 4, total: 8, expected: DailyProgressStage.percent40),
      (completed: 6, total: 10, expected: DailyProgressStage.percent60),
      (completed: 5, total: 8, expected: DailyProgressStage.percent60),
      (completed: 8, total: 10, expected: DailyProgressStage.percent80),
      (completed: 7, total: 8, expected: DailyProgressStage.percent80),
      (completed: 8, total: 8, expected: DailyProgressStage.percent100),
      (completed: 39, total: 100, expected: DailyProgressStage.percent20),
      (completed: 59, total: 100, expected: DailyProgressStage.percent40),
      (completed: 79, total: 100, expected: DailyProgressStage.percent60),
      (completed: 99, total: 100, expected: DailyProgressStage.percent80),
      (completed: 9, total: 8, expected: DailyProgressStage.percent100),
    ];

    for (final testCase in cases) {
      test('${testCase.completed}/${testCase.total} resolves to '
          '${testCase.expected.name}', () {
        expect(
          resolveDailyProgressStage(
            completedCount: testCase.completed,
            totalCount: testCase.total,
          ),
          testCase.expected,
        );
      });
    }
  });
}
