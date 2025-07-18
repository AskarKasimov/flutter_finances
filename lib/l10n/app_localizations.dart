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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Finances'**
  String get appTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get languageSystem;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @useSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Use system theme'**
  String get useSystemTheme;

  /// No description provided for @primaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary color (tint)'**
  String get primaryColor;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @pinCode.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get pinCode;

  /// No description provided for @biometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometrics;

  /// No description provided for @biometricsSetPinFirst.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN code first'**
  String get biometricsSetPinFirst;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @pinSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set PIN code'**
  String get pinSetTitle;

  /// No description provided for @pinEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN code'**
  String get pinEnterTitle;

  /// No description provided for @pinFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get pinFieldLabel;

  /// No description provided for @pinStatusSet.
  ///
  /// In en, this message translates to:
  /// **'PIN code is set'**
  String get pinStatusSet;

  /// No description provided for @pinStatusNotSet.
  ///
  /// In en, this message translates to:
  /// **'PIN code is not set'**
  String get pinStatusNotSet;

  /// No description provided for @pinSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get pinSave;

  /// No description provided for @pinLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get pinLogin;

  /// No description provided for @pinDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete PIN code'**
  String get pinDelete;

  /// No description provided for @pinErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'PIN code must be 4 digits'**
  String get pinErrorInvalid;

  /// No description provided for @pinErrorWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN code'**
  String get pinErrorWrong;

  /// No description provided for @pinDeleted.
  ///
  /// In en, this message translates to:
  /// **'PIN code deleted, biometrics disabled'**
  String get pinDeleted;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @statsPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'By day'**
  String get statsPeriodDay;

  /// No description provided for @statsPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get statsPeriodMonth;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @ruble.
  ///
  /// In en, this message translates to:
  /// **'Ruble'**
  String get ruble;

  /// No description provided for @usd.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usd;

  /// No description provided for @eur.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get eur;

  /// No description provided for @editAccountName.
  ///
  /// In en, this message translates to:
  /// **'Edit account name'**
  String get editAccountName;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @enterAccountName.
  ///
  /// In en, this message translates to:
  /// **'Enter account name'**
  String get enterAccountName;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccount;

  /// No description provided for @myItems.
  ///
  /// In en, this message translates to:
  /// **'My items'**
  String get myItems;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchByName;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// No description provided for @noComment.
  ///
  /// In en, this message translates to:
  /// **'<no comment>'**
  String get noComment;

  /// No description provided for @startPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: start'**
  String get startPeriod;

  /// No description provided for @endPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: end'**
  String get endPeriod;

  /// No description provided for @summa.
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get summa;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @transactionCreated.
  ///
  /// In en, this message translates to:
  /// **'Transaction successfully added'**
  String get transactionCreated;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errorUnknown;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @transactionEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get transactionEditTitle;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get accountNotSelected;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get categoryNotSelected;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get amountNotSpecified;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Comment...'**
  String get commentHint;

  /// No description provided for @selectAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccountTitle;

  /// No description provided for @errorLoadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get errorLoadingCategories;

  /// No description provided for @incomesToday.
  ///
  /// In en, this message translates to:
  /// **'Your incomes for the day'**
  String get incomesToday;

  /// No description provided for @expensesToday.
  ///
  /// In en, this message translates to:
  /// **'Your expenses for the day'**
  String get expensesToday;

  /// No description provided for @incomesEmptyToday.
  ///
  /// In en, this message translates to:
  /// **'Your incomes for the day will appear here'**
  String get incomesEmptyToday;

  /// No description provided for @expensesEmptyToday.
  ///
  /// In en, this message translates to:
  /// **'Your expenses for the day will appear here'**
  String get expensesEmptyToday;

  /// No description provided for @addByPlus.
  ///
  /// In en, this message translates to:
  /// **'Add by pressing the plus'**
  String get addByPlus;

  /// No description provided for @myHistory.
  ///
  /// In en, this message translates to:
  /// **'My history'**
  String get myHistory;

  /// No description provided for @unknownState.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownState;

  /// No description provided for @sortByDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortByDateDesc;

  /// No description provided for @sortByDateAsc.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortByDateAsc;

  /// No description provided for @sortByAmountDesc.
  ///
  /// In en, this message translates to:
  /// **'Largest amounts first'**
  String get sortByAmountDesc;

  /// No description provided for @sortByAmountAsc.
  ///
  /// In en, this message translates to:
  /// **'Smallest amounts first'**
  String get sortByAmountAsc;

  /// No description provided for @transactionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your transactions will appear here'**
  String get transactionsEmpty;

  /// No description provided for @biometricAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to access your finances'**
  String get biometricAuthReason;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
