import 'package:app_aq_2/core/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/home/cubit/home_cubit.dart';

final _appRouter = createAppRouter();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(getIt(), getIt())..load(),
      child: MaterialApp.router(
        title: 'Rahhal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: _appRouter,
      ),
    );
  }
}
