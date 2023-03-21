import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends BlocWithStatus<HomeEvent, HomeState, HomeInfo, dynamic> {
  final AuthService _authService;
  StreamSubscription<String?>? _loggedUserEmailListener;

  HomeBloc({
    required AuthService authService,
    BlocStatus status = const BlocStatusInitial(),
    HomePage currentPage = HomePage.currentWeek,
  })  : _authService = authService,
        super(
          HomeState(
            status: status,
            currentPage: currentPage,
          ),
        ) {
    on<HomeEventInitialize>(_initialize);
    on<HomeEventLoggedUserEmailChanged>(_loggedUserEmailChanged);
    on<HomeEventCurrentPageChanged>(_currentPageChanged);
    on<HomeEventSignOut>(_signOut);
  }

  @override
  Future<void> close() {
    _loggedUserEmailListener?.cancel();
    _loggedUserEmailListener = null;
    return super.close();
  }

  void _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) {
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

  void _loggedUserEmailChanged(
    HomeEventLoggedUserEmailChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      loggedUserEmail: event.loggedUserEmail,
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
}
