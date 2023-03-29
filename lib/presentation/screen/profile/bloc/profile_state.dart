import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class ProfileState extends BlocState {
  final String? userId;
  final String? username;
  final String? surname;
  final String? email;

  const ProfileState({
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
  ProfileState copyWith({
    BlocStatus? status,
    String? userId,
    String? username,
    String? surname,
    String? email,
  }) {
    return ProfileState(
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
}

enum ProfileError {
  emailAlreadyInUse,
  wrongPassword,
  wrongCurrentPassword,
}
