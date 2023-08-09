part of 'clients_search_bloc.dart';

class ClientsSearchState extends BlocState<ClientsSearchState> {
  final String searchText;
  final List<Client>? clients;

  const ClientsSearchState({
    required super.status,
    required this.searchText,
    this.clients,
  });

  @override
  List<Object?> get props => [status, searchText, clients];

  @override
  ClientsSearchState copyWith({
    BlocStatus? status,
    String? searchText,
    List<Client>? clients,
  }) =>
      ClientsSearchState(
        status: status ?? const BlocStatusComplete(),
        searchText: searchText ?? this.searchText,
        clients: clients ?? this.clients,
      );
}
