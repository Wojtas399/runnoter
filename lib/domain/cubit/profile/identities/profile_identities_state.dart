part of 'profile_identities_cubit.dart';

class ProfileIdentitiesState extends CubitState {
  final AccountType? accountType;
  final Gender? gender;
  final String? name;
  final String? surname;
  final String? email;
  final DateTime? dateOfBirth;
  final bool? isEmailVerified;

  const ProfileIdentitiesState({
    required super.status,
    this.accountType,
    this.gender,
    this.name,
    this.surname,
    this.email,
    this.dateOfBirth,
    this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        gender,
        name,
        surname,
        email,
        dateOfBirth,
        isEmailVerified,
      ];

  @override
  ProfileIdentitiesState copyWith({
    BlocStatus? status,
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    DateTime? dateOfBirth,
    bool? isEmailVerified,
  }) =>
      ProfileIdentitiesState(
        status: status ?? const BlocStatusComplete(),
        accountType: accountType ?? this.accountType,
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      );
}
