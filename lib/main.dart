import 'package:app_aq_2/core/router/app_router.dart';
import 'package:app_aq_2/presentation/splash/cubit/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final router = createAppRouter();

    return BlocProvider(
      create: (context) => SplashCubit(),

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,

        routerConfig: router,

        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}