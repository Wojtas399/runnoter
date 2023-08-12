part of 'clients_bloc.dart';

class ClientsState extends BlocState<ClientsState> {
  final List<InvitedPerson>? invitedPersons;
  final List<Person>? clients;

  const ClientsState({
    required super.status,
    this.invitedPersons,
    this.clients,
  });

  @override
  List<Object?> get props => [status, invitedPersons, clients];

  @override
  ClientsState copyWith({
    BlocStatus? status,
    List<InvitedPerson>? invitedPersons,
    List<Person>? clients,
  }) =>
      ClientsState(
        status: status ?? const BlocStatusComplete(),
        invitedPersons: invitedPersons ?? this.invitedPersons,
        clients: clients ?? this.clients,
      );
}

class InvitedPerson extends Equatable {
  final String coachingRequestId;
  final Person person;

  const InvitedPerson({required this.coachingRequestId, required this.person});

  @override
  List<Object?> get props => [coachingRequestId, person];
}
