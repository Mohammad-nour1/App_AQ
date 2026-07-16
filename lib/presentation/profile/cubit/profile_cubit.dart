import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/auth_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void loadProfile() {
    emit(
      ProfileLoaded(
        email: AuthService.currentEmail ?? 'user@example.com',
        name: AuthService.currentName ?? 'User Name',
      ),
    );
  }

  Future<void> logout() async {
    emit(ProfileLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    AuthService.logout();
    emit(ProfileLoggedOut());
  }
}
