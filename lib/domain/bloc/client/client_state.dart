part of 'client_bloc.dart';

class ClientState extends BlocState<ClientState> {
  final Gender? gender;
  final String? name;
  final String? surname;
  final String? email;

  const ClientState({
    required super.status,
    this.gender,
    this.name,
    this.surname,
    this.email,
  });

  @override
  List<Object?> get props => [status, gender, name, surname];

  @override
  ClientState copyWith({
    BlocStatus? status,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
  }) =>
      ClientState(
        status: status ?? const BlocStatusComplete(),
        gender: gender ?? this.gender,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        email: email ?? this.email,
      );
}
