import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc
    extends BlocWithStatus<ProfileEvent, ProfileState, ProfileInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<String?>? _emailListener;
  StreamSubscription<User?>? _userDataListener;

  ProfileBloc({
    required AuthService authService,
    required UserRepository userRepository,
    BlocStatus status = const BlocStatusInitial(),
    String? userId,
    String? username,
    String? surname,
    String? email,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(
          ProfileState(
            status: status,
            userId: userId,
            username: username,
            surname: surname,
            email: email,
          ),
        ) {
    on<ProfileEventInitialize>(_initialize);
    on<ProfileEventEmailUpdated>(_emailUpdated);
    on<ProfileEventUserUpdated>(_userUpdated);
    on<ProfileEventUpdateUsername>(_updateUsername);
    on<ProfileEventUpdateSurname>(_updateSurname);
  }

  @override
  Future<void> close() {
    _emailListener?.cancel();
    _emailListener = null;
    _userDataListener?.cancel();
    _userDataListener = null;
    return super.close();
  }

  void _initialize(
    ProfileEventInitialize event,
    Emitter<ProfileState> emit,
  ) {
    _setEmailListener();
    _setUserDataListener();
  }

  void _emailUpdated(
    ProfileEventEmailUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _userUpdated(
    ProfileEventUserUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      userId: 'u1',
      username: event.user?.name,
      surname: event.user?.surname,
    ));
  }

  Future<void> _updateUsername(
    ProfileEventUpdateUsername event,
    Emitter<ProfileState> emit,
  ) async {
    final String? userId = state.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUser(
      userId: userId,
      name: event.username,
    );
    emitCompleteStatus(emit, ProfileInfo.savedData);
  }

  Future<void> _updateSurname(
    ProfileEventUpdateSurname event,
    Emitter<ProfileState> emit,
  ) async {
    final String? userId = state.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUser(
      userId: userId,
      surname: event.surname,
    );
    emitCompleteStatus(emit, ProfileInfo.savedData);
  }

  void _setEmailListener() {
    _emailListener ??= _authService.loggedUserEmail$.listen(
      (String? email) {
        add(
          ProfileEventEmailUpdated(
            email: email,
          ),
        );
      },
    );
  }

  void _setUserDataListener() {
    _userDataListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String userId) => _userRepository.getUserById(
            userId: userId,
          ),
        )
        .listen(
      (User? user) {
        add(
          ProfileEventUserUpdated(
            user: user,
          ),
        );
      },
    );
  }
}
