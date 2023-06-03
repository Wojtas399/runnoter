import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';

class ProfileIdentitiesState extends BlocState {
  final String? userId;
  final String? username;
  final String? surname;
  final String? email;

  const ProfileIdentitiesState({
    required super.status,
    required this.userId,
    required this.username,
    required this.surname,
    required this.email,
  });

  @override
  List<Object?> get props => [
        status,
        userId,
        username,
        surname,
        email,
      ];

  @override
  ProfileIdentitiesState copyWith({
    BlocStatus? status,
    String? userId,
    String? username,
    String? surname,
    String? email,
  }) {
    return ProfileIdentitiesState(
      status: status ?? const BlocStatusComplete(),
      userId: userId ?? this.userId,
      username: username ?? this.username,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }
}

enum ProfileInfo {
  savedData,
  accountDeleted,
}

enum ProfileError {
  emailAlreadyInUse,
  wrongPassword,
  wrongCurrentPassword,
}
