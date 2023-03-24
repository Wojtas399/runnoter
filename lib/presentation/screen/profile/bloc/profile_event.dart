import 'package:equatable/equatable.dart';

import '../../../../domain/model/user.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileEventInitialize extends ProfileEvent {
  const ProfileEventInitialize();
}

class ProfileEventEmailUpdated extends ProfileEvent {
  final String? email;

  const ProfileEventEmailUpdated({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}

class ProfileEventUserUpdated extends ProfileEvent {
  final User? user;

  const ProfileEventUserUpdated({
    required this.user,
  });

  @override
  List<Object?> get props => [
        user,
      ];
}
