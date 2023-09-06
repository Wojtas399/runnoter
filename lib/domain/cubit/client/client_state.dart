part of 'client_cubit.dart';

class ClientState extends CubitState<ClientState> {
  final Gender? gender;
  final String? name;
  final String? surname;
  final String? email;
  final DateTime? dateOfBirth;

  const ClientState({
    required super.status,
    this.gender,
    this.name,
    this.surname,
    this.email,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [status, gender, name, surname, dateOfBirth];

  @override
  ClientState copyWith({
    BlocStatus? status,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    DateTime? dateOfBirth,
  }) =>
      ClientState(
        status: status ?? const BlocStatusComplete(),
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      );
}
