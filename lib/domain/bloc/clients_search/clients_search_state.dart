part of 'clients_search_bloc.dart';

class ClientsSearchState extends BlocState<ClientsSearchState> {
  final String searchText;
  final List<UserBasicInfo>? foundUsers;

  const ClientsSearchState({
    required super.status,
    required this.searchText,
    this.foundUsers,
  });

  @override
  List<Object?> get props => [status, searchText, foundUsers];

  @override
  ClientsSearchState copyWith({
    BlocStatus? status,
    String? searchText,
    List<UserBasicInfo>? foundUsers,
  }) =>
      ClientsSearchState(
        status: status ?? const BlocStatusComplete(),
        searchText: searchText ?? this.searchText,
        foundUsers: foundUsers ?? this.foundUsers,
      );
}
