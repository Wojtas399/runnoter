import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/user_basic_info.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'users_search_event.dart';
part 'users_search_state.dart';

class UsersSearchBloc extends BlocWithStatus<UsersSearchEvent, UsersSearchState,
    UsersSearchBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final CoachingRequestService _coachingRequestService;

  UsersSearchBloc({
    UsersSearchState state = const UsersSearchState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(state) {
    on<UsersSearchEventInitialize>(_initialize);
    on<UsersSearchEventSearch>(_search);
    on<UsersSearchEventInviteUser>(_inviteUser);
  }

  Future<void> _initialize(
    UsersSearchEventInitialize event,
    Emitter<UsersSearchState> emit,
  ) async {
    final stream$ = _authService.loggedUserId$.whereNotNull().switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _getClientIds(loggedUserId),
            _coachingRequestService
                .getCoachingRequestsBySenderId(senderId: loggedUserId)
                .whereNotNull(),
            (List<String> clientIds,
                    List<CoachingRequest> sentCoachingRequests) =>
                (clientIds, sentCoachingRequests),
          ),
        );
    await emit.forEach(
      stream$,
      onData: ((List<String>, List<CoachingRequest>) data) {
        final clientIds = {...data.$1, ...data.$2.clientIds}.toList();
        final invitedUserIds = data.$2.invitedUserIds;
        return state.copyWith(
          clientIds: clientIds,
          invitedUserIds: invitedUserIds,
          foundUsers: state.foundUsers != null
              ? _updateFoundUsers(clientIds, invitedUserIds)
              : null,
        );
      },
    );
  }

  Future<void> _search(
    UsersSearchEventSearch event,
    Emitter<UsersSearchState> emit,
  ) async {
    if (event.searchQuery.isEmpty) {
      emit(state.copyWith(
        status: const BlocStatusComplete(),
        setFoundUsersAsNull: true,
      ));
      return;
    }
    emitLoadingStatus(emit);
    final List<User> foundUsers =
        await _userRepository.searchForUsers(searchQuery: event.searchQuery);
    emit(state.copyWith(
      foundUsers: _addRelationshipStatusForUsers(foundUsers),
    ));
  }

  Future<void> _inviteUser(
    UsersSearchEventInviteUser event,
    Emitter<UsersSearchState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _coachingRequestService.addCoachingRequest(
      senderId: loggedUserId,
      receiverId: event.idOfUserToInvite,
      status: CoachingRequestStatus.pending,
    );
    emitCompleteStatus(emit, info: UsersSearchBlocInfo.requestSent);
  }

  Stream<List<String>> _getClientIds(String loggedUserId) =>
      _userRepository.getUsersByCoachId(coachId: loggedUserId).map(
            (List<User>? users) => [...?users?.map((User user) => user.id)],
          );

  List<FoundUser> _updateFoundUsers(
    List<String> clientIds,
    List<String> invitedUserIds,
  ) {
    final List<FoundUser> updatedFoundUsers = [];
    for (final user in [...?state.foundUsers]) {
      final RelationshipStatus status = _selectUserRelationshipStatus(
        userId: user.info.id,
        clientIds: clientIds,
        invitedUserIds: invitedUserIds,
      );
      updatedFoundUsers.add(user.copyWithStatus(status));
    }
    return updatedFoundUsers;
  }

  List<FoundUser> _addRelationshipStatusForUsers(List<User> users) => users
      .map(
        (User user) => FoundUser(
          info: UserBasicInfo(
            id: user.id,
            gender: user.gender,
            name: user.name,
            surname: user.surname,
            email: user.email,
          ),
          relationshipStatus: _selectUserRelationshipStatus(
            userId: user.id,
            clientIds: state.clientIds,
            invitedUserIds: state.invitedUserIds,
          ),
        ),
      )
      .toList();

  RelationshipStatus _selectUserRelationshipStatus({
    required String userId,
    required List<String> clientIds,
    required List<String> invitedUserIds,
  }) {
    if (clientIds.contains(userId)) {
      return RelationshipStatus.accepted;
    } else if (invitedUserIds.contains(userId)) {
      return RelationshipStatus.pending;
    } else {
      return RelationshipStatus.notInvited;
    }
  }
}

enum UsersSearchBlocInfo { requestSent }

extension _CoachingRequestsExtensions on List<CoachingRequest> {
  List<String> get clientIds => where((coachingRequest) =>
          coachingRequest.status == CoachingRequestStatus.accepted)
      .map((coachingRequest) => coachingRequest.receiverId)
      .toList();

  List<String> get invitedUserIds => where((coachingRequest) =>
          coachingRequest.status == CoachingRequestStatus.pending)
      .map((coachingRequest) => coachingRequest.receiverId)
      .toList();
}
