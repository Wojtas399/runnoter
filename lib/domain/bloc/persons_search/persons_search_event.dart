part of 'persons_search_bloc.dart';

abstract class PersonsSearchEvent {
  const PersonsSearchEvent();
}

class PersonsSearchEventInitialize extends PersonsSearchEvent {
  const PersonsSearchEventInitialize();
}

class PersonsSearchEventSearch extends PersonsSearchEvent {
  final String searchQuery;

  const PersonsSearchEventSearch({required this.searchQuery});
}

class PersonsSearchEventInvitePerson extends PersonsSearchEvent {
  final String personId;

  const PersonsSearchEventInvitePerson({required this.personId});
}
