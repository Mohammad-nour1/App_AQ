import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashCubitState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initialize() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(SplashCompleted());
  }
}
