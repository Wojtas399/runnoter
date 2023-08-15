part of 'clients_bloc.dart';

class ClientsState extends BlocState<ClientsState> {
  final List<CoachingRequestDetails>? sentRequests;
  final List<CoachingRequestDetails>? receivedRequests;
  final List<Person>? clients;

  const ClientsState({
    required super.status,
    this.sentRequests,
    this.receivedRequests,
    this.clients,
  });

  @override
  List<Object?> get props => [status, sentRequests, receivedRequests, clients];

  @override
  ClientsState copyWith({
    BlocStatus? status,
    List<CoachingRequestDetails>? sentRequests,
    List<CoachingRequestDetails>? receivedRequests,
    List<Person>? clients,
  }) =>
      ClientsState(
        status: status ?? const BlocStatusComplete(),
        sentRequests: sentRequests ?? this.sentRequests,
        receivedRequests: receivedRequests ?? this.receivedRequests,
        clients: clients ?? this.clients,
      );
}

class CoachingRequestDetails extends Equatable {
  final String id;
  final Person personToDisplay;

  const CoachingRequestDetails({
    required this.id,
    required this.personToDisplay,
  });

  @override
  List<Object?> get props => [id, personToDisplay];
}
