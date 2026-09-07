// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Goalkeeper Trainer';

  @override
  String get mainMenuTitle => 'MAIN MENU';

  @override
  String get homeTitle => 'Main Menu';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get registrationTitle => 'Registration';

  @override
  String get goalkeepersTitle => 'Goalkeepers';

  @override
  String get diaryTitle => 'Goal Diary';

  @override
  String get analyticsTitle => 'Goal Analytics';

  @override
  String get game1Title => 'Reaction Game';

  @override
  String get schulteTableTitle => 'Schulte Table';

  @override
  String get game2Title => 'Air Hockey';

  @override
  String get aeroHockeyTitle => 'Air Hockey';

  @override
  String get authorsTitle => 'Authors';

  @override
  String get developersClub => 'Developed by 1C PRO Consulting Developers Club';

  @override
  String get methodologyAuthor => 'Methodology: Anton Shustov';

  @override
  String get programAuthors => 'Program Authors:';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get soundEnabled => 'Sound';

  @override
  String get volume => 'Volume';

  @override
  String get language => 'Language';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get back => 'Back';

  @override
  String get dailyTasksTitle => 'Daily Tasks';

  @override
  String get dailyTasksAdd => 'Add task';

  @override
  String get dailyTasksEdit => 'Edit task';

  @override
  String get dailyTasksTaskTitle => 'Task title';

  @override
  String get dailyTasksDescription => 'Description';

  @override
  String get dailyTasksActive => 'Active';

  @override
  String get delete => 'Delete';

  @override
  String get dailyTasksDelete => 'Delete task';

  @override
  String get dailyTasksDeleteConfirmation => 'Delete this task?';

  @override
  String get dailyTasksEmpty => 'No daily tasks yet. Add your first task.';

  @override
  String get dailyTasksNoGoalkeeper =>
      'Select a goalkeeper to view daily tasks.';

  @override
  String get dailyTasksChooseGoalkeeper => 'Choose or create goalkeeper';

  @override
  String dailyTasksForGoalkeeper(String name) {
    return 'Tasks for $name';
  }

  @override
  String dailyTasksOwner(String name) {
    return 'Goalkeeper: $name';
  }

  @override
  String get dailyTasksGoalkeeperChanged =>
      'The active goalkeeper changed. Return to the updated task list.';

  @override
  String get dailyTasksReturnToList => 'Return to tasks';

  @override
  String get dailyTasksLoadError => 'Could not load daily tasks.';

  @override
  String get dailyTasksSaveError => 'Could not save the task.';

  @override
  String get dailyTasksTitleRequired => 'Enter a task title.';

  @override
  String get dailyTasksStatistics => 'Statistics';

  @override
  String get dailyTasksCompletedToday => 'Completed today';

  @override
  String get dailyTasksActiveTotal => 'Active tasks';

  @override
  String get dailyTasksCompletionPercent => 'Completion today';

  @override
  String get dailyTasksCompletedTodayLabel => 'Completed\ntoday';

  @override
  String get dailyTasksActiveTasksLabel => 'Active\ntasks';

  @override
  String get dailyTasksCompletionPercentLabel => 'Completion\ntoday';

  @override
  String get dailyTasksRecentCompletedDays => 'Recent completed days';

  @override
  String get dailyTasksLastSevenDays => 'Recent completed days';

  @override
  String get dailyTasksNoCompletedStatistics =>
      'No completed task statistics yet';

  @override
  String get dailyTasksProgressTitle => 'Day progress';

  @override
  String dailyTasksProgressCompletedToday(int percent) {
    return '$percent% completed today';
  }

  @override
  String dailyTasksProgressCompletedForDay(int percent) {
    return '$percent% completed for the day';
  }

  @override
  String get dailyTasksProgressNoTasks => 'No active tasks for this day';

  @override
  String get dailyTasksProgressCompletedState => 'a clean sheet for the day';

  @override
  String get dailyTasksProgress0Message1 =>
      'The empty ice is waiting — lace up and get started.';

  @override
  String get dailyTasksProgress0Message2 =>
      'Zero on the scoreboard. Time for the first step.';

  @override
  String get dailyTasksProgress0Message3 =>
      'A goalkeeper\'s journey starts with one move. Let\'s go!';

  @override
  String get dailyTasksProgress20Message1 =>
      'The first step is done — the ice is moving.';

  @override
  String get dailyTasksProgress20Message2 =>
      'Warmed up? It only gets more interesting.';

  @override
  String get dailyTasksProgress20Message3 =>
      'First task in the net. Mark it down.';

  @override
  String get dailyTasksProgress40Message1 =>
      'You\'re heading the right way — keep the pace.';

  @override
  String get dailyTasksProgress40Message2 =>
      'Almost halfway — the opponent is feeling the pressure.';

  @override
  String get dailyTasksProgress40Message3 =>
      'You\'ve picked up speed, now don\'t slow down.';

  @override
  String get dailyTasksProgress60Message1 =>
      'Decide what kind of goalkeeper you want to be — and go.';

  @override
  String get dailyTasksProgress60Message2 =>
      'Past the halfway mark — character is tested here.';

  @override
  String get dailyTasksProgress60Message3 =>
      'It\'s clear who came to work. Keep going.';

  @override
  String get dailyTasksProgress80Message1 =>
      'Just a little left — a great day to grow.';

  @override
  String get dailyTasksProgress80Message2 =>
      'One final push for today\'s clean sheet.';

  @override
  String get dailyTasksProgress80Message3 =>
      'You\'ve almost locked down the day. Finish strong.';

  @override
  String get dailyTasksProgress100Message1 =>
      'Clean sheet! Great job — do it again tomorrow.';

  @override
  String get dailyTasksProgress100Message2 =>
      'One hundred percent — that\'s character. Keep it up!';

  @override
  String get dailyTasksProgress100Message3 =>
      'Every puck stopped, every task completed.';

  @override
  String get dailyTaskBuiltInWellbeingDiary => 'Complete the wellbeing diary';

  @override
  String get dailyTaskBuiltInMorningRoutine => 'Morning routine';

  @override
  String get dailyTaskBuiltInPreTrainingWarmup =>
      'Warm up before training/game';

  @override
  String get dailyTaskBuiltInReactionCoordination =>
      'Reaction and coordination exercises';

  @override
  String get dailyTaskBuiltInMobility => 'Mobility: hips, ankles, back';

  @override
  String get dailyTaskBuiltInReading => 'Read a book';

  @override
  String get dailyTaskBuiltInPhoneBeforeSleep =>
      'Put the phone away an hour before sleep';

  @override
  String get dailyTaskBuiltInSleepOnTime => 'Sleep: go to bed on time';
}
