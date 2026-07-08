import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/presentation/home/cubit/home_cubit.dart';
import 'package:app_aq_2/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMapScreen extends StatelessWidget {
  const HomeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..load(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Explore'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: BlocBuilder<HomeCubit, HomeCubitState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
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
    return const Center(
      child: Text('Home Map Screen'),
    );
  }
}
