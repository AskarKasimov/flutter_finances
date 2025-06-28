import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_account_repository.dart';
import 'package:flutter_finances/data/repositories/mocks/mocked_category_repository.dart';
import 'package:flutter_finances/ui/blocs/account/account_state_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AccountBloc(MockedAccountRepository())),
        BlocProvider(
          create: (_) => CategoryBloc(repository: MockedCategoryRepository()),
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
    );
  }
}
