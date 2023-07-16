import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../additional_model/bloc_state.dart';
import '../../entity/settings.dart';
import '../../entity/user.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc
    extends BlocWithStatus<HomeEvent, HomeState, HomeBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;

  HomeBloc({
    required AuthService authService,
    required UserRepository userRepository,
    HomeState state = const HomeState(status: BlocStatusInitial()),
  })  : _authService = authService,
        _userRepository = userRepository,
        super(state) {
    on<HomeEventInitialize>(_initialize);
    on<HomeEventSignOut>(_signOut);
  }

  Future<void> _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) async {
    emitLoadingStatus(emit);
    final Stream<User?> loggedUser$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => _userRepository.getUserById(
                userId: loggedUserId,
              ),
            );
    await emit.forEach(
      loggedUser$,
      onData: (User? loggedUser) => state.copyWith(
        loggedUserName: loggedUser?.name,
        appSettings: loggedUser?.settings,
      ),
    );
  }

  Future<void> _signOut(
    HomeEventSignOut event,
    Emitter<HomeState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _authService.signOut();
    emitCompleteStatus(emit, HomeBlocInfo.userSignedOut);
  }
}

enum HomeBlocInfo {
  userSignedOut,
}
