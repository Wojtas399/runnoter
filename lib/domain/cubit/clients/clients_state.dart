part of 'clients_cubit.dart';

class ClientsState extends CubitState<ClientsState> {
  final List<CoachingRequestShort>? sentRequests;
  final List<CoachingRequestShort>? receivedRequests;
  final List<Person>? clients;
  final String? selectedChatId;

  const ClientsState({
    required super.status,
    this.sentRequests,
    this.receivedRequests,
    this.clients,
    this.selectedChatId,
  });

  @override
  List<Object?> get props => [
        status,
        sentRequests,
        receivedRequests,
        clients,
        selectedChatId,
      ];

  @override
  ClientsState copyWith({
    CubitStatus? status,
    List<CoachingRequestShort>? sentRequests,
    List<CoachingRequestShort>? receivedRequests,
    List<Person>? clients,
    String? selectedChatId,
  }) =>
      ClientsState(
        status: status ?? const CubitStatusComplete(),
        sentRequests: sentRequests ?? this.sentRequests,
        receivedRequests: receivedRequests ?? this.receivedRequests,
        clients: clients ?? this.clients,
        selectedChatId: selectedChatId,
      );
}
