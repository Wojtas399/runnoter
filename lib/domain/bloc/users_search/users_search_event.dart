part of 'users_search_bloc.dart';

abstract class UsersSearchEvent {
  const UsersSearchEvent();
}

class UsersSearchEventSearch extends UsersSearchEvent {
  final String searchText;

  const UsersSearchEventSearch({required this.searchText});
}
