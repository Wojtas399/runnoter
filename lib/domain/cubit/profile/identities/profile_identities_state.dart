part of 'profile_identities_cubit.dart';

class ProfileIdentitiesState extends CubitState {
  final AccountType? accountType;
  final Gender? gender;
  final String? username;
  final String? surname;
  final String? email;
  final bool? isEmailVerified;

  const ProfileIdentitiesState({
    required super.status,
    this.accountType,
    this.gender,
    this.username,
    this.surname,
    this.email,
    this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        gender,
        username,
        surname,
        email,
        isEmailVerified,
      ];

  @override
  ProfileIdentitiesState copyWith({
    BlocStatus? status,
    AccountType? accountType,
    Gender? gender,
    String? username,
    String? surname,
    String? email,
    bool? isEmailVerified,
  }) =>
      ProfileIdentitiesState(
        status: status ?? const BlocStatusComplete(),
        accountType: accountType ?? this.accountType,
        gender: gender ?? this.gender,
        username: username ?? this.username,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      );
}
