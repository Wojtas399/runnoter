part of 'clients_bloc.dart';

class ClientsState extends BlocState<ClientsState> {
  final List<CoachingRequestShort>? sentRequests;
  final List<CoachingRequestShort>? receivedRequests;
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
    List<CoachingRequestShort>? sentRequests,
    List<CoachingRequestShort>? receivedRequests,
    List<Person>? clients,
  }) =>
      ClientsState(
        status: status ?? const BlocStatusComplete(),
        sentRequests: sentRequests ?? this.sentRequests,
        receivedRequests: receivedRequests ?? this.receivedRequests,
        clients: clients ?? this.clients,
      );
}
