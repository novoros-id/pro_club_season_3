// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Тренировка Вратарей';

  @override
  String get mainMenuTitle => 'ОСНОВНОЕ МЕНЮ';

  @override
  String get homeTitle => 'Главное меню';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get registrationTitle => 'Регистрация';

  @override
  String get goalkeepersTitle => 'Вратари';

  @override
  String get diaryTitle => 'Дневник голов';

  @override
  String get analyticsTitle => 'Аналитика голов';

  @override
  String get game1Title => 'Игра: Реакция';

  @override
  String get schulteTableTitle => 'Таблица Шульте';

  @override
  String get game2Title => 'Игра: Аэрохоккей';

  @override
  String get aeroHockeyTitle => 'Аэрохоккей';

  @override
  String get authorsTitle => 'Авторы';

  @override
  String get developersClub =>
      'Разработано в клубе разработчиков 1С ПРО Консалтинг';

  @override
  String get methodologyAuthor => 'Методика: Антон Шустов';

  @override
  String get programAuthors => 'Авторы программы:';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get soundEnabled => 'Звук';

  @override
  String get volume => 'Громкость';

  @override
  String get language => 'Язык';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get back => 'Назад';

  @override
  String get dailyTasksTitle => 'Ежедневные задачи';

  @override
  String get dailyTasksAdd => 'Добавить задачу';

  @override
  String get dailyTasksEdit => 'Редактировать задачу';

  @override
  String get dailyTasksTaskTitle => 'Название задачи';

  @override
  String get dailyTasksDescription => 'Описание';

  @override
  String get dailyTasksActive => 'Активна';

  @override
  String get delete => 'Удалить';

  @override
  String get dailyTasksDelete => 'Удалить задачу';

  @override
  String get dailyTasksDeleteConfirmation => 'Удалить эту задачу?';

  @override
  String get dailyTasksEmpty => 'Задач пока нет. Добавьте первую задачу.';

  @override
  String get dailyTasksNoGoalkeeper =>
      'Выберите вратаря, чтобы увидеть ежедневные задачи.';

  @override
  String get dailyTasksChooseGoalkeeper => 'Выбрать или создать вратаря';

  @override
  String dailyTasksForGoalkeeper(String name) {
    return 'Задачи для: $name';
  }

  @override
  String dailyTasksOwner(String name) {
    return 'Вратарь: $name';
  }

  @override
  String get dailyTasksGoalkeeperChanged =>
      'Активный вратарь изменился. Вернитесь к обновлённому списку задач.';

  @override
  String get dailyTasksReturnToList => 'Вернуться к задачам';

  @override
  String get dailyTasksLoadError => 'Не удалось загрузить ежедневные задачи.';

  @override
  String get dailyTasksSaveError => 'Не удалось сохранить задачу.';

  @override
  String get dailyTasksTitleRequired => 'Введите название задачи.';

  @override
  String get dailyTasksStatistics => 'Статистика';

  @override
  String get dailyTasksCompletedToday => 'Выполнено сегодня';

  @override
  String get dailyTasksActiveTotal => 'Всего активных задач';

  @override
  String get dailyTasksCompletionPercent => 'Процент выполнения сегодня';

  @override
  String get dailyTasksCompletedTodayLabel => 'Выполнено\nсегодня';

  @override
  String get dailyTasksActiveTasksLabel => 'Активные\nзадачи';

  @override
  String get dailyTasksCompletionPercentLabel => 'Процент\nсегодня';

  @override
  String get dailyTasksRecentCompletedDays => 'Последние выполненные дни';

  @override
  String get dailyTasksLastSevenDays => 'Последние выполненные дни';

  @override
  String get dailyTasksNoCompletedStatistics =>
      'Статистики выполненных задач пока нет';
}
