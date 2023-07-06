import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../additional_model/bloc_state.dart';
import '../../entity/settings.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BlocWithStatus<HomeEvent, HomeState, HomeInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<HomeStateListenedParams?>? _listenedParamsListener;

  HomeBloc({
    required AuthService authService,
    required UserRepository userRepository,
    BlocStatus status = const BlocStatusInitial(),
  })  : _authService = authService,
        _userRepository = userRepository,
        super(
          HomeState(
            status: status,
          ),
        ) {
    on<HomeEventInitialize>(_initialize);
    on<HomeEventListenedParamsChanged>(_listenedParamsChanged);
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
      distanceUnit: event.listenedParams?.distanceUnit,
      paceUnit: event.listenedParams?.paceUnit,
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
        distanceUnit: loggedUserData?.settings.distanceUnit,
        paceUnit: loggedUserData?.settings.paceUnit,
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
