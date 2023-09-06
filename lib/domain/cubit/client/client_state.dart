part of 'client_cubit.dart';

class ClientState extends Equatable {
  final Gender? gender;
  final String? name;
  final String? surname;
  final String? email;
  final DateTime? dateOfBirth;

  const ClientState({
    this.gender,
    this.name,
    this.surname,
    this.email,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [gender, name, surname, dateOfBirth];

  ClientState copyWith({
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    DateTime? dateOfBirth,
  }) =>
      ClientState(
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      );
}
