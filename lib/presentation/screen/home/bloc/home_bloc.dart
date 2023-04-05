import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends BlocWithStatus<HomeEvent, HomeState, HomeInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<String?>? _loggedUserEmailListener;
  StreamSubscription<User?>? _loggedUserDataListener;

  HomeBloc({
    required AuthService authService,
    required UserRepository userRepository,
    BlocStatus status = const BlocStatusInitial(),
    HomePage currentPage = HomePage.currentWeek,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(
          HomeState(
            status: status,
            currentPage: currentPage,
          ),
        ) {
    on<HomeEventInitialize>(_initialize);
    on<HomeEventLoggedUserEmailChanged>(_loggedUserEmailChanged);
    on<HomeEventLoggedUserDataChanged>(_loggedUserDataChanged);
    on<HomeEventCurrentPageChanged>(_currentPageChanged);
    on<HomeEventSignOut>(_signOut);
  }

  @override
  Future<void> close() {
    _loggedUserEmailListener?.cancel();
    _loggedUserEmailListener = null;
    _loggedUserDataListener?.cancel();
    _loggedUserDataListener = null;
    return super.close();
  }

  void _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) {
    _setLoggedUserEmailListener();
    _setLoggedUserDataListener();
  }

  void _loggedUserEmailChanged(
    HomeEventLoggedUserEmailChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      loggedUserEmail: event.loggedUserEmail,
    ));
  }

  void _loggedUserDataChanged(
    HomeEventLoggedUserDataChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      loggedUserName: event.loggedUserData?.name,
      loggedUserSurname: event.loggedUserData?.surname,
      themeMode: event.loggedUserData?.settings.themeMode,
    ));
  }

  void _currentPageChanged(
    HomeEventCurrentPageChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      currentPage: event.currentPage,
    ));
  }

  Future<void> _signOut(
    HomeEventSignOut event,
    Emitter<HomeState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _authService.signOut();
    emitCompleteStatus(emit, HomeInfo.userSignedOut);
  }

  void _setLoggedUserEmailListener() {
    _loggedUserEmailListener ??= _authService.loggedUserEmail$.listen(
      (String? loggedUserEmail) {
        add(
          HomeEventLoggedUserEmailChanged(
            loggedUserEmail: loggedUserEmail,
          ),
        );
      },
    );
  }

  void _setLoggedUserDataListener() {
    _loggedUserDataListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => _userRepository.getUserById(
            userId: loggedUserId,
          ),
        )
        .listen(
      (User? loggedUserData) {
        add(
          HomeEventLoggedUserDataChanged(
            loggedUserData: loggedUserData,
          ),
        );
      },
    );
  }
}
