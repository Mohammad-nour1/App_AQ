import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  HomeCubit() : super(HomeInitial());

  Future<void> load() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(HomeLoaded());
  }
}
