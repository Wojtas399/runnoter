part of 'users_search_bloc.dart';

class UsersSearchState extends BlocState<UsersSearchState> {
  final List<UserBasicInfo>? foundUsers;

  const UsersSearchState({
    required super.status,
    this.foundUsers,
  });

  @override
  List<Object?> get props => [status, foundUsers];

  @override
  UsersSearchState copyWith({
    BlocStatus? status,
    List<UserBasicInfo>? foundUsers,
  }) =>
      UsersSearchState(
        status: status ?? const BlocStatusComplete(),
        foundUsers: foundUsers,
      );
}
