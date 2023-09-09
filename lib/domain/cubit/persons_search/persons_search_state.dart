part of 'persons_search_cubit.dart';

class PersonsSearchState extends CubitState<PersonsSearchState> {
  final String searchQuery;
  final List<String> clientIds;
  final List<String> invitedPersonIds;
  final List<FoundPerson>? foundPersons;

  const PersonsSearchState({
    required super.status,
    this.searchQuery = '',
    this.clientIds = const [],
    this.invitedPersonIds = const [],
    this.foundPersons,
  });

  @override
  List<Object?> get props => [
        status,
        searchQuery,
        clientIds,
        invitedPersonIds,
        foundPersons,
      ];

  @override
  PersonsSearchState copyWith({
    CubitStatus? status,
    String? searchQuery,
    List<String>? clientIds,
    List<String>? invitedPersonIds,
    List<FoundPerson>? foundPersons,
    bool setFoundPersonsAsNull = false,
  }) =>
      PersonsSearchState(
        status: status ?? const CubitStatusComplete(),
        searchQuery: searchQuery ?? this.searchQuery,
        clientIds: clientIds ?? this.clientIds,
        invitedPersonIds: invitedPersonIds ?? this.invitedPersonIds,
        foundPersons:
            setFoundPersonsAsNull ? null : foundPersons ?? this.foundPersons,
      );
}

enum RelationshipStatus { notInvited, alreadyTaken, pending, accepted }

class FoundPerson extends Equatable {
  final Person info;
  final RelationshipStatus relationshipStatus;

  const FoundPerson({
    required this.info,
    required this.relationshipStatus,
  });

  @override
  List<Object?> get props => [info, relationshipStatus];

  FoundPerson copyWithStatus(RelationshipStatus status) => FoundPerson(
        info: info,
        relationshipStatus: status,
      );
}
