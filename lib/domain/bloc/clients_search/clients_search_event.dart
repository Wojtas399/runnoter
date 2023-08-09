part of 'clients_search_bloc.dart';

abstract class ClientsSearchEvent {
  const ClientsSearchEvent();
}

class ClientsSearchEventSearchTextChanged extends ClientsSearchEvent {
  final String searchText;

  const ClientsSearchEventSearchTextChanged({required this.searchText});
}

class ClientsSearchEventSearch extends ClientsSearchEvent {
  const ClientsSearchEventSearch();
}
