import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final String email;
  final String name;

  const ProfileLoaded({required this.email, required this.name});

  @override
  List<Object?> get props => [email, name];
}

class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}
