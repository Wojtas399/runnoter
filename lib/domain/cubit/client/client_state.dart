part of 'client_cubit.dart';

class ClientState extends CubitState<ClientState> {
  final Gender? gender;
  final String? name;
  final String? surname;
  final String? email;
  final int? age;

  const ClientState({
    required super.status,
    this.gender,
    this.name,
    this.surname,
    this.email,
    this.age,
  });

  @override
  List<Object?> get props => [status, gender, name, surname, age];

  @override
  ClientState copyWith({
    BlocStatus? status,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    int? age,
  }) =>
      ClientState(
        status: status ?? const BlocStatusComplete(),
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
        age: age ?? this.age,
      );
}
