import 'package:equatable/equatable.dart';

import '../../entity/user.dart';

class PersonDetailsState extends Equatable {
  final Gender? gender;
  final String? name;
  final String? surname;
  final String? email;
  final DateTime? dateOfBirth;

  const PersonDetailsState({
    this.gender,
    this.name,
    this.surname,
    this.email,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [gender, name, surname, email, dateOfBirth];

  PersonDetailsState copyWith({
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    DateTime? dateOfBirth,
  }) =>
      PersonDetailsState(
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      );
}
