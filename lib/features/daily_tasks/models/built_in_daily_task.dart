import '../../../l10n/app_localizations.dart';

class BuiltInDailyTaskDefinition {
  final String key;
  final String title;
  final int sortOrder;

  const BuiltInDailyTaskDefinition({
    required this.key,
    required this.title,
    required this.sortOrder,
  });
}

const builtInDailyTasks = <BuiltInDailyTaskDefinition>[
  BuiltInDailyTaskDefinition(
    key: 'wellbeing_diary',
    title: 'Заполнить дневник самочувствия',
    sortOrder: 0,
  ),
  BuiltInDailyTaskDefinition(
    key: 'morning_routine',
    title: 'Утренние процедуры',
    sortOrder: 1,
  ),
  BuiltInDailyTaskDefinition(
    key: 'pre_training_warmup',
    title: 'Разминка перед тренировкой/игрой',
    sortOrder: 2,
  ),
  BuiltInDailyTaskDefinition(
    key: 'reaction_coordination',
    title: 'Упражнения на реакцию и координацию',
    sortOrder: 3,
  ),
  BuiltInDailyTaskDefinition(
    key: 'mobility',
    title: 'Мобильность: тазобедренные, голеностоп, спина',
    sortOrder: 4,
  ),
  BuiltInDailyTaskDefinition(
    key: 'reading',
    title: 'Чтение книги',
    sortOrder: 5,
  ),
  BuiltInDailyTaskDefinition(
    key: 'phone_before_sleep',
    title: 'Убрать телефон за час до сна',
    sortOrder: 6,
  ),
  BuiltInDailyTaskDefinition(
    key: 'sleep_on_time',
    title: 'Сон: лечь вовремя',
    sortOrder: 7,
  ),
];

String builtInDailyTaskTitle(AppLocalizations l10n, String? key) =>
    switch (key) {
      'wellbeing_diary' => l10n.dailyTaskBuiltInWellbeingDiary,
      'morning_routine' => l10n.dailyTaskBuiltInMorningRoutine,
      'pre_training_warmup' => l10n.dailyTaskBuiltInPreTrainingWarmup,
      'reaction_coordination' => l10n.dailyTaskBuiltInReactionCoordination,
      'mobility' => l10n.dailyTaskBuiltInMobility,
      'reading' => l10n.dailyTaskBuiltInReading,
      'phone_before_sleep' => l10n.dailyTaskBuiltInPhoneBeforeSleep,
      'sleep_on_time' => l10n.dailyTaskBuiltInSleepOnTime,
      _ => '',
    };
