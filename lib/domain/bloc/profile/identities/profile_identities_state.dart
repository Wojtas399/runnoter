part of 'profile_identities_bloc.dart';

class ProfileIdentitiesState extends BlocState {
  final Gender? gender;
  final String? username;
  final String? surname;
  final String? email;

  const ProfileIdentitiesState({
    required super.status,
    this.gender,
    this.username,
    this.surname,
    this.email,
  });

  @override
  List<Object?> get props => [
        status,
        gender,
        username,
        surname,
        email,
      ];

  @override
  ProfileIdentitiesState copyWith({
    BlocStatus? status,
    Gender? gender,
    String? username,
    String? surname,
    String? email,
  }) {
    return ProfileIdentitiesState(
      status: status ?? const BlocStatusComplete(),
      gender: gender ?? this.gender,
      username: username ?? this.username,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }
}
