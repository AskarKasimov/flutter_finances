import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/local_data/database/app_database.dart';
import 'package:flutter_finances/data/remote/api_client.dart';
import 'package:flutter_finances/data/remote/services/account_api_service.dart';
import 'package:flutter_finances/data/remote/services/category_api_service.dart';
import 'package:flutter_finances/data/remote/services/transaction_api_service.dart';
import 'package:flutter_finances/data/repositories/account_repository_impl.dart';
import 'package:flutter_finances/data/repositories/biometric_settings_repository_impl.dart';
import 'package:flutter_finances/data/repositories/category_repository_impl.dart';
import 'package:flutter_finances/data/repositories/secure_pin_code_storage_impl.dart';
import 'package:flutter_finances/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_finances/data/sync/sync_service.dart';
import 'package:flutter_finances/domain/repositories/account_repository.dart';
import 'package:flutter_finances/domain/repositories/biometric_settings_repository.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';
import 'package:flutter_finances/domain/repositories/pin_code_storage.dart';
import 'package:flutter_finances/domain/repositories/transaction_repository.dart';
import 'package:flutter_finances/domain/usecases/create_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/delete_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/delete_transaction_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_account_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_accounts_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:flutter_finances/domain/usecases/get_transactions_by_period_usecase.dart';
import 'package:flutter_finances/domain/usecases/is_biometric_enabled_usecase.dart';
import 'package:flutter_finances/domain/usecases/save_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/set_biometric_enabled_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_account_usecase.dart';
import 'package:flutter_finances/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter_finances/l10n/app_localizations.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/locale_controller.dart';
import 'package:flutter_finances/ui/router.dart';
import 'package:flutter_finances/ui/theme/theme.dart';
import 'package:flutter_finances/ui/theme/theme_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:secure_application/secure_application.dart';
import 'package:worker_manager/worker_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация worker_manager
  await workerManager.init();

  // Инициализация базы данных
  await AppDatabase.instance.ensureInitialized();

  // Инициализация API клиента
  final apiClient = ApiClient();

  // Инициализация ThemeController
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.loadThemeMode();

  // Инициализация PinCodeStorage
  final pinCodeStorage = SecurePinCodeStorageImpl(
    secureStorage: const FlutterSecureStorage(),
  );

  final biometricSettingsRepository = BiometricSettingsRepositoryImpl(
    secureStorage: const FlutterSecureStorage(),
  );

  final localeController = LocaleController();
  await localeController.loadLocale();

  runApp(
    SecureApplication(
      child: MyApp(
        apiClient: apiClient,
        themeController: themeController,
        pinCodeStorage: pinCodeStorage,
        biometricSettingsRepository: biometricSettingsRepository,
        localeController: localeController,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  final ThemeController themeController;
  final PinCodeStorage pinCodeStorage;
  final BiometricSettingsRepository biometricSettingsRepository;
  final LocaleController localeController;

  const MyApp({
    super.key,
    required this.apiClient,
    required this.themeController,
    required this.pinCodeStorage,
    required this.biometricSettingsRepository,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context);

    return MultiRepositoryProvider(
      providers: [
        ChangeNotifierProvider<LocaleController>.value(value: localeController),
        RepositoryProvider<IsBiometricEnabledUseCase>(
          create: (_) => IsBiometricEnabledUseCase(
            repository: biometricSettingsRepository,
          ),
        ),
        RepositoryProvider<SetBiometricEnabledUseCase>(
          create: (_) => SetBiometricEnabledUseCase(
            repository: biometricSettingsRepository,
          ),
        ),
        RepositoryProvider<SavePinCodeUseCase>(
          create: (_) => SavePinCodeUseCase(pinCodeStorage),
        ),
        RepositoryProvider<GetPinCodeUseCase>(
          create: (_) => GetPinCodeUseCase(pinCodeStorage),
        ),
        RepositoryProvider<DeletePinCodeUseCase>(
          create: (_) => DeletePinCodeUseCase(pinCodeStorage),
        ),
        ChangeNotifierProvider<ThemeController>.value(value: themeController),
        RepositoryProvider<ApiClient>(create: (_) => ApiClient()),
        RepositoryProvider<TransactionApiService>(
          create: (context) =>
              TransactionApiService(dio: context.read<ApiClient>().dio),
        ),
        RepositoryProvider<AccountApiService>(
          create: (context) =>
              AccountApiService(dio: context.read<ApiClient>().dio),
        ),
        RepositoryProvider<CategoryApiService>(
          create: (context) =>
              CategoryApiService(dio: context.read<ApiClient>().dio),
        ),
        RepositoryProvider<SyncService>(
          create: (context) => SyncService(
            syncEventDao: AppDatabase.instance.syncEventDao,
            transactionApi: context.read<TransactionApiService>(),
            accountApi: context.read<AccountApiService>(),
            categoryApi: context.read<CategoryApiService>(),
          ),
        ),
        RepositoryProvider<TransactionRepository>(
          create: (context) => TransactionRepositoryImpl(
            context.read<TransactionApiService>(),
            AppDatabase.instance.transactionDao,
            AppDatabase.instance.syncEventDao,
            context.read<SyncService>(),
          ),
        ),
        RepositoryProvider<AccountRepository>(
          create: (context) => AccountRepositoryImpl(
            AppDatabase.instance.accountDao,
            context.read<AccountApiService>(),
            AppDatabase.instance.syncEventDao,
            context.read<SyncService>(),
          ),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(
            context.read<CategoryApiService>(),
            AppDatabase.instance.categoryDao,
            context.read<SyncService>(),
          ),
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
        child: Consumer<ThemeController>(
          builder: (context, themeController, _) {
            return Consumer<LocaleController>(
              builder: (context, localeController, _) {
                return MaterialApp.router(
                  title:
                      AppLocalizations.of(context)?.appTitle ??
                      'Flutter Finances',
                  debugShowCheckedModeBanner: false,
                  theme: getLightTheme(themeController.tintColor),
                  darkTheme: getDarkTheme(themeController.tintColor),
                  themeMode: themeController.themeMode,
                  routerConfig: router,
                  locale: localeController.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
