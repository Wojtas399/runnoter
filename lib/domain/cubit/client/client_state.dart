part of 'client_cubit.dart';

class ClientState extends Equatable {
  final String? name;
  final String? surname;

  const ClientState({this.name, this.surname});

  @override
  List<Object?> get props => [name, surname];

  ClientState copyWith({
    String? name,
    String? surname,
  }) =>
      ClientState(
        name: name ?? this.name,
        surname: surname ?? this.surname,
      );
}
