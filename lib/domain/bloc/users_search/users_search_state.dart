part of 'users_search_bloc.dart';

class UsersSearchState extends BlocState<UsersSearchState> {
  final List<String> clientIds;
  final List<String> invitedUserIds;
  final List<FoundUser>? foundUsers;

  const UsersSearchState({
    required super.status,
    this.clientIds = const [],
    this.invitedUserIds = const [],
    this.foundUsers,
  });

  @override
  List<Object?> get props => [status, clientIds, invitedUserIds, foundUsers];

  @override
  UsersSearchState copyWith({
    BlocStatus? status,
    List<String>? clientIds,
    List<String>? invitedUserIds,
    List<FoundUser>? foundUsers,
    bool setFoundUsersAsNull = false,
  }) =>
      UsersSearchState(
        status: status ?? const BlocStatusComplete(),
        clientIds: clientIds ?? this.clientIds,
        invitedUserIds: invitedUserIds ?? this.invitedUserIds,
        foundUsers: setFoundUsersAsNull ? null : foundUsers ?? this.foundUsers,
      );
}

enum RelationshipStatus { notInvited, alreadyTaken, pending, accepted }

class FoundUser extends Equatable {
  final UserBasicInfo info;
  final RelationshipStatus relationshipStatus;

  const FoundUser({
    required this.info,
    required this.relationshipStatus,
  });

  @override
  List<Object?> get props => [info, relationshipStatus];

  FoundUser copyWithStatus(RelationshipStatus status) => FoundUser(
        info: info,
        relationshipStatus: status,
      );
}
