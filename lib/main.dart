import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/remote/api_client.dart';
import 'package:flutter_finances/data/remote/services/account_api_service.dart';
import 'package:flutter_finances/data/remote/services/category_api_service.dart';
import 'package:flutter_finances/data/remote/services/transaction_api_service.dart';
import 'package:flutter_finances/data/repositories/account_repository_impl.dart';
import 'package:flutter_finances/data/repositories/category_repository_impl.dart';
import 'package:flutter_finances/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';
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
  final apiClient = ApiClient();
  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;

  const MyApp({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TransactionRepository>(
          create: (_) => TransactionRepositoryImpl(
            TransactionApiService(dio: apiClient.dio),
          ),
        ),
        RepositoryProvider<AccountRepository>(
          create: (_) =>
              AccountRepositoryImpl(AccountApiService(dio: apiClient.dio)),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (_) =>
              CategoryRepositoryImpl(CategoryApiService(dio: apiClient.dio)),
        ),
        RepositoryProvider(
          create: (context) => CreateTransactionUseCase(
            transactionRepository: context.read<TransactionRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => DeleteTransactionUseCase(
            transactionRepository: context.read<TransactionRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetAccountByIdUseCase(
            accountRepository: context.read<AccountRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetAllAccountsUseCase(
            accountRepository: context.read<AccountRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetAllCategoriesUseCase(
            categoryRepository: context.read<CategoryRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetTransactionByIdUseCase(
            transactionRepository: context.read<TransactionRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => GetTransactionsByPeriodUseCase(
            transactionRepository: context.read<TransactionRepository>(),
            categoryRepository: context.read<CategoryRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => UpdateAccountUseCase(
            accountRepository: context.read<AccountRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => UpdateTransactionUseCase(
            transactionRepository: context.read<TransactionRepository>(),
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
