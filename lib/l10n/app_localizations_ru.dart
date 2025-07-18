// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Flutter Финансы';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageSystem => 'Системный язык';

  @override
  String get settings => 'Настройки';

  @override
  String get useSystemTheme => 'Использовать системную тему';

  @override
  String get primaryColor => 'Основной цвет (тинт)';

  @override
  String get cancel => 'Отмена';

  @override
  String get select => 'Выбрать';

  @override
  String get pinCode => 'Пин-код';

  @override
  String get biometrics => 'Биометрия';

  @override
  String get biometricsSetPinFirst => 'Сначала установите пин-код';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get pinSetTitle => 'Установить Пин-код';

  @override
  String get pinEnterTitle => 'Введите Пин-код';

  @override
  String get pinFieldLabel => 'Пин-код';

  @override
  String get pinStatusSet => 'Пин-код установлен';

  @override
  String get pinStatusNotSet => 'Пин-код не задан';

  @override
  String get pinSave => 'Сохранить';

  @override
  String get pinLogin => 'Войти';

  @override
  String get pinDelete => 'Удалить пинкод';

  @override
  String get pinErrorInvalid => 'Пин-код должен быть 4 цифры';

  @override
  String get pinErrorWrong => 'Неверный пин-код';

  @override
  String get pinDeleted => 'Пин-код удалён, биометрия отключена';

  @override
  String get noDataFound => 'Нет данных';

  @override
  String get statsPeriodDay => 'По дням';

  @override
  String get statsPeriodMonth => 'По месяцам';

  @override
  String get balance => 'Баланс';

  @override
  String get currency => 'Валюта';

  @override
  String get ruble => 'Рубль';

  @override
  String get usd => 'Доллар США';

  @override
  String get eur => 'Евро';

  @override
  String get editAccountName => 'Редактировать имя счёта';

  @override
  String get accountName => 'Имя счёта';

  @override
  String get enterAccountName => 'Введите имя счёта';

  @override
  String get myAccount => 'Мой счёт';

  @override
  String get myItems => 'Мои статьи';

  @override
  String get searchByName => 'Поиск по названию';

  @override
  String get analysis => 'Аналитика';

  @override
  String get noComment => '<нет комментария>';

  @override
  String get startPeriod => 'Период: начало';

  @override
  String get endPeriod => 'Период: конец';

  @override
  String get summa => 'Сумма';

  @override
  String get addIncome => 'Добавить доход';

  @override
  String get addExpense => 'Добавить расход';

  @override
  String get transactionCreated => 'Транзакция успешно добавлена';

  @override
  String get errorTitle => 'Ошибка';

  @override
  String get errorUnknown => 'Неизвестная ошибка';

  @override
  String get ok => 'ОК';

  @override
  String get transactionEditTitle => 'Редактировать транзакцию';

  @override
  String get delete => 'Удалить';

  @override
  String get account => 'Счёт';

  @override
  String get accountNotSelected => 'Не выбран';

  @override
  String get category => 'Статья';

  @override
  String get categoryNotSelected => 'Не выбрано';

  @override
  String get amount => 'Сумма';

  @override
  String get amountNotSpecified => 'Не указано';

  @override
  String get enterAmount => 'Введите сумму';

  @override
  String get date => 'Дата';

  @override
  String get time => 'Время';

  @override
  String get commentHint => 'Комментарий...';

  @override
  String get selectAccountTitle => 'Выберите счёт';

  @override
  String get errorLoadingCategories => 'Ошибка загрузки категорий';

  @override
  String get incomesToday => 'Твои доходы за день';

  @override
  String get expensesToday => 'Твои расходы за день';

  @override
  String get incomesEmptyToday => 'Здесь будут твои доходы за день';

  @override
  String get expensesEmptyToday => 'Здесь будут твои расходы за день';

  @override
  String get addByPlus => 'Добавь нажатием на плюсик';

  @override
  String get myHistory => 'Моя история';

  @override
  String get unknownState => 'Неизвестное состояние';

  @override
  String get sortByDateDesc => 'Сначала новые';

  @override
  String get sortByDateAsc => 'Сначала старые';

  @override
  String get sortByAmountDesc => 'Сначала большие суммы';

  @override
  String get sortByAmountAsc => 'Сначала меньшие суммы';

  @override
  String get transactionsEmpty => 'Здесь будут твои транзакции';

  @override
  String get biometricAuthReason => 'Войдите с помощью биометрии';
}
