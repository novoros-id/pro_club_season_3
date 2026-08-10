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
}
