import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..load(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: BlocBuilder<HomeCubit, HomeCubitState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const LoadingIndicator();
            }
            if (state is HomeLoaded) {
              return _buildContent(context);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return const SizedBox.shrink();
  }
}
