import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_account_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/router.dart';
import 'package:flutter_finances/ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MockedTransactionRepository>(
          create: (_) => MockedTransactionRepository(),
        ),
        RepositoryProvider<MockedCategoryRepository>(
          create: (_) => MockedCategoryRepository(),
        ),
        RepositoryProvider<MockedAccountRepository>(
          create: (_) => MockedAccountRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AccountBloc(context.read<MockedAccountRepository>()),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              repository: context.read<MockedCategoryRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Flutter Finance',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: router,
        ),
      ),
    );
  }
}
