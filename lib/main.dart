import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_account_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/create_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/delete_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_account_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_accounts_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_account_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/router.dart';
import 'package:flutter_finances/ui/theme.dart';
import 'package:worker_manager/worker_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await workerManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => MockedTransactionRepository()),
        RepositoryProvider(create: (_) => MockedAccountRepository()),
        RepositoryProvider(create: (_) => MockedCategoryRepository()),
        RepositoryProvider(
          create: (context) => CreateTransactionUseCase(
            transactionRepository: context.read<MockedTransactionRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => DeleteTransactionUseCase(
            transactionRepository: context.read<MockedTransactionRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetAccountByIdUseCase(
            accountRepository: context.read<MockedAccountRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetAllAccountsUseCase(
            accountRepository: context.read<MockedAccountRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetAllCategoriesUseCase(
            categoryRepository: context.read<MockedCategoryRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetTransactionByIdUseCase(
            transactionRepository: context.read<MockedTransactionRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetTransactionsByPeriodUseCase(
            transactionRepository: context.read<MockedTransactionRepository>(),
            categoryRepository: context.read<MockedCategoryRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => UpdateAccountUseCase(
            accountRepository: context.read<MockedAccountRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => UpdateTransactionUseCase(
            transactionRepository: context.read<MockedTransactionRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AccountBloc(
              getAccountByIdUseCase: context.read<GetAccountByIdUseCase>(),
              updateAccountUseCase: context.read<UpdateAccountUseCase>(),
            ),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(
              getAllCategoriesUseCase: context.read<GetAllCategoriesUseCase>(),
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
