import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/entities/category.dart';
import 'package:flutter_finances/domain/entities/transaction.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/ui/theme/theme.dart';
import 'package:flutter_finances/ui/widgets/transactions_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryBloc extends Mock implements CategoryBloc {}

class FakeAppLocalizations extends Fake implements AppLocalizations {
  @override
  String get transactionsEmpty => 'Нет транзакций';

  @override
  String get errorLoadingCategories => 'Ошибка загрузки категорий';

  @override
  String get sortByDateDesc => 'Сначала новые';

  @override
  String get sortByDateAsc => 'Сначала старые';

  @override
  String get sortByAmountDesc => 'Сначала большие суммы';

  @override
  String get sortByAmountAsc => 'Сначала маленькие суммы';

  @override
  String get total => 'Всего';
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('TransactionsList golden test with transactions', (tester) async {
    final categoryBloc = MockCategoryBloc();

    final categories = [
      Category(id: 1, emoji: ':)', name: 'Хавчик', isIncome: true),
    ];

    final transactions = [
      Transaction(
        id: 1,
        categoryId: 1,
        amount: 100.0,
        timestamp: DateTime(2023, 7, 25, 14, 0),
        comment: 'Обед',
        accountId: 2,
      ),
      Transaction(
        id: 2,
        categoryId: 1,
        amount: 50.0,
        timestamp: DateTime(2023, 7, 26, 10, 0),
        comment: '',
        accountId: 1,
      ),
    ];

    when(() => categoryBloc.state).thenReturn(CategoryLoaded(categories));
    when(() => categoryBloc.state).thenReturn(CategoryLoaded(categories));
    when(
      () => categoryBloc.stream,
    ).thenAnswer((_) => Stream.value(CategoryLoaded(categories)));

    await tester.pumpWidgetBuilder(
      BlocProvider<CategoryBloc>.value(
        value: categoryBloc,
        child: MaterialApp(
          theme: getLightTheme(Colors.blue),
          darkTheme: getDarkTheme(Colors.blue),
          themeMode: ThemeMode.light,
          localizationsDelegates: const [],
          home: Builder(
            builder: (context) {
              return Localizations.override(
                context: context,
                delegates: const [_FakeAppLocalizationsDelegate()],
                child: TransactionsList(
                  transactions: transactions,
                  onTapTransaction: (_) {},
                  showTime: true,
                  showSortMethods: true,
                  currency: '₽',
                ),
              );
            },
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'transactions_list_with_transactions');
  });

  testGoldens('TransactionsList golden test empty state', (tester) async {
    final categoryBloc = MockCategoryBloc();

    when(() => categoryBloc.state).thenReturn(CategoryLoaded([]));
    when(() => categoryBloc.state).thenReturn(CategoryLoaded([]));
    when(
      () => categoryBloc.stream,
    ).thenAnswer((_) => Stream.value(CategoryLoaded([])));

    await tester.pumpWidgetBuilder(
      BlocProvider<CategoryBloc>.value(
        value: categoryBloc,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return Localizations.override(
                context: context,
                delegates: const [_FakeAppLocalizationsDelegate()],
                child: TransactionsList(
                  transactions: const [],
                  onTapTransaction: (_) {},
                  currency: '₽',
                ),
              );
            },
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'transactions_list_empty');
  });
}

class _FakeAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _FakeAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return FakeAppLocalizations();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
