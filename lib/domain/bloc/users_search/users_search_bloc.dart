import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/invitation.dart';
import '../../additional_model/user_basic_info.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/invitation_service.dart';

part 'users_search_event.dart';
part 'users_search_state.dart';

class UsersSearchBloc extends BlocWithStatus<UsersSearchEvent, UsersSearchState,
    UsersSearchBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final InvitationService _invitationService;

  UsersSearchBloc({
    UsersSearchState state = const UsersSearchState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _invitationService = getIt<InvitationService>(),
        super(state) {
    on<UsersSearchEventSearch>(_search);
    on<UsersSearchEventInviteUser>(_inviteUser);
  }

  Future<void> _search(
    UsersSearchEventSearch event,
    Emitter<UsersSearchState> emit,
  ) async {
    if (event.searchText.isEmpty) {
      emit(state.copyWith(
        status: const BlocStatusComplete(),
        foundUsersAsNull: true,
      ));
      return;
    }
    emitLoadingStatus(emit);
    final List<User> foundUsers = await _userRepository.searchForUsers(
      name: event.searchText,
      surname: event.searchText,
      email: event.searchText,
    );
    emit(state.copyWith(
      foundUsers: _getUsersBasicInfo(foundUsers),
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
    await _invitationService.addInvitation(
      senderId: loggedUserId,
      receiverId: event.idOfUserToInvite,
      status: InvitationStatus.pending,
    );
    emitCompleteStatus(emit, info: UsersSearchBlocInfo.invitationSent);
  }

  List<UserBasicInfo> _getUsersBasicInfo(List<User> users) => users
      .map(
        (User user) => UserBasicInfo(
          id: user.id,
          gender: user.gender,
          name: user.name,
          surname: user.surname,
          email: user.email,
        ),
      )
      .toList();
}

enum UsersSearchBlocInfo { invitationSent }
