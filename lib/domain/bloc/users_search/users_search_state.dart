part of 'users_search_bloc.dart';

class UsersSearchState extends BlocState<UsersSearchState> {
  final String searchQuery;
  final List<String> clientIds;
  final List<String> invitedPersonIds;
  final List<FoundPerson>? foundPersons;

  const UsersSearchState({
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
  UsersSearchState copyWith({
    BlocStatus? status,
    String? searchQuery,
    List<String>? clientIds,
    List<String>? invitedPersonIds,
    List<FoundPerson>? foundPersons,
    bool setFoundPersonsAsNull = false,
  }) =>
      UsersSearchState(
        status: status ?? const BlocStatusComplete(),
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
