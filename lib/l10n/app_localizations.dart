import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Goalkeeper Trainer'**
  String get appName;

  /// No description provided for @mainMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'MAIN MENU'**
  String get mainMenuTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get homeTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registrationTitle;

  /// No description provided for @goalkeepersTitle.
  ///
  /// In en, this message translates to:
  /// **'Goalkeepers'**
  String get goalkeepersTitle;

  /// No description provided for @diaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal Diary'**
  String get diaryTitle;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal Analytics'**
  String get analyticsTitle;

  /// No description provided for @game1Title.
  ///
  /// In en, this message translates to:
  /// **'Reaction Game'**
  String get game1Title;

  /// No description provided for @schulteTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Schulte Table'**
  String get schulteTableTitle;

  /// No description provided for @game2Title.
  ///
  /// In en, this message translates to:
  /// **'Air Hockey'**
  String get game2Title;

  /// No description provided for @aeroHockeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Air Hockey'**
  String get aeroHockeyTitle;

  /// No description provided for @authorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get authorsTitle;

  /// No description provided for @developersClub.
  ///
  /// In en, this message translates to:
  /// **'Developed by 1C PRO Consulting Developers Club'**
  String get developersClub;

  /// No description provided for @methodologyAuthor.
  ///
  /// In en, this message translates to:
  /// **'Methodology: Anton Shustov'**
  String get methodologyAuthor;

  /// No description provided for @programAuthors.
  ///
  /// In en, this message translates to:
  /// **'Program Authors:'**
  String get programAuthors;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @soundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get soundEnabled;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @dailyTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Tasks'**
  String get dailyTasksTitle;

  /// No description provided for @dailyTasksAdd.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get dailyTasksAdd;

  /// No description provided for @dailyTasksEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get dailyTasksEdit;

  /// No description provided for @dailyTasksTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get dailyTasksTaskTitle;

  /// No description provided for @dailyTasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get dailyTasksDescription;

  /// No description provided for @dailyTasksActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dailyTasksActive;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @dailyTasksDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get dailyTasksDelete;

  /// No description provided for @dailyTasksDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete this task?'**
  String get dailyTasksDeleteConfirmation;

  /// No description provided for @dailyTasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No daily tasks yet. Add your first task.'**
  String get dailyTasksEmpty;

  /// No description provided for @dailyTasksNoGoalkeeper.
  ///
  /// In en, this message translates to:
  /// **'Select a goalkeeper to view daily tasks.'**
  String get dailyTasksNoGoalkeeper;

  /// No description provided for @dailyTasksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load daily tasks.'**
  String get dailyTasksLoadError;

  /// No description provided for @dailyTasksSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the task.'**
  String get dailyTasksSaveError;

  /// No description provided for @dailyTasksTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a task title.'**
  String get dailyTasksTitleRequired;

  /// No description provided for @dailyTasksStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get dailyTasksStatistics;

  /// No description provided for @dailyTasksCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get dailyTasksCompletedToday;

  /// No description provided for @dailyTasksActiveTotal.
  ///
  /// In en, this message translates to:
  /// **'Active tasks'**
  String get dailyTasksActiveTotal;

  /// No description provided for @dailyTasksCompletionPercent.
  ///
  /// In en, this message translates to:
  /// **'Completion today'**
  String get dailyTasksCompletionPercent;

  /// No description provided for @dailyTasksCompletedTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed\ntoday'**
  String get dailyTasksCompletedTodayLabel;

  /// No description provided for @dailyTasksActiveTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Active\ntasks'**
  String get dailyTasksActiveTasksLabel;

  /// No description provided for @dailyTasksCompletionPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Completion\ntoday'**
  String get dailyTasksCompletionPercentLabel;

  /// No description provided for @dailyTasksRecentCompletedDays.
  ///
  /// In en, this message translates to:
  /// **'Recent completed days'**
  String get dailyTasksRecentCompletedDays;

  /// No description provided for @dailyTasksLastSevenDays.
  ///
  /// In en, this message translates to:
  /// **'Recent completed days'**
  String get dailyTasksLastSevenDays;

  /// No description provided for @dailyTasksNoCompletedStatistics.
  ///
  /// In en, this message translates to:
  /// **'No completed task statistics yet'**
  String get dailyTasksNoCompletedStatistics;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
