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
  StreamSubscription<HomeStateListenedParams?>? _listenedParamsListener;

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
    on<HomeEventListenedParamsChanged>(_listenedParamsChanged);
    on<HomeEventCurrentPageChanged>(_currentPageChanged);
    on<HomeEventSignOut>(_signOut);
  }

  @override
  Future<void> close() {
    _listenedParamsListener?.cancel();
    _listenedParamsListener = null;
    return super.close();
  }

  _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) {
    emitLoadingStatus(emit);
    _setListenedParamsListener();
  }

  void _listenedParamsChanged(
    HomeEventListenedParamsChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      loggedUserEmail: event.listenedParams?.loggedUserEmail,
      loggedUserName: event.listenedParams?.loggedUserName,
      loggedUserSurname: event.listenedParams?.loggedUserSurname,
      themeMode: event.listenedParams?.themeMode,
      language: event.listenedParams?.language,
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

  void _setListenedParamsListener() {
    _listenedParamsListener ??= Rx.combineLatest2(
      _authService.loggedUserEmail$,
      _getLoggedUserData(),
      (String? loggedUserEmail, User? loggedUserData) =>
          HomeStateListenedParams(
        loggedUserEmail: loggedUserEmail,
        loggedUserName: loggedUserData?.name,
        loggedUserSurname: loggedUserData?.surname,
        themeMode: loggedUserData?.settings.themeMode,
        language: loggedUserData?.settings.language,
      ),
    ).listen((HomeStateListenedParams listenedParams) {
      add(
        HomeEventListenedParamsChanged(
          listenedParams: listenedParams,
        ),
      );
    });
  }

  Stream<User?> _getLoggedUserData() {
    return _authService.loggedUserId$.whereType<String>().switchMap(
          (String loggedUserId) => _userRepository.getUserById(
            userId: loggedUserId,
          ),
        );
  }
}
