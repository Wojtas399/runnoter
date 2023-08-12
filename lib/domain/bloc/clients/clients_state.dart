part of 'clients_bloc.dart';

class ClientsState extends BlocState<ClientsState> {
  final List<SentCoachingRequest>? sentRequests;
  final List<Person>? clients;

  const ClientsState({
    required super.status,
    this.sentRequests,
    this.clients,
  });

  @override
  List<Object?> get props => [status, sentRequests, clients];

  @override
  ClientsState copyWith({
    BlocStatus? status,
    List<SentCoachingRequest>? sentRequests,
    List<Person>? clients,
  }) =>
      ClientsState(
        status: status ?? const BlocStatusComplete(),
        sentRequests: sentRequests ?? this.sentRequests,
        clients: clients ?? this.clients,
      );
}

class SentCoachingRequest extends Equatable {
  final String requestId;
  final Person receiver;

  const SentCoachingRequest({required this.requestId, required this.receiver});

  @override
  List<Object?> get props => [requestId, receiver];
}
