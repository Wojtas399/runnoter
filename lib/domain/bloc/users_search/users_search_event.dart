part of 'users_search_bloc.dart';

abstract class UsersSearchEvent {
  const UsersSearchEvent();
}

class UsersSearchEventInitialize extends UsersSearchEvent {
  const UsersSearchEventInitialize();
}

class UsersSearchEventSearch extends UsersSearchEvent {
  final String searchQuery;

  const UsersSearchEventSearch({required this.searchQuery});
}

class UsersSearchEventInviteUser extends UsersSearchEvent {
  final String idOfUserToInvite;

  const UsersSearchEventInviteUser({required this.idOfUserToInvite});
}
