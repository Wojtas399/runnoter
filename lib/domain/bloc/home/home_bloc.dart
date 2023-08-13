import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/settings.dart';
import '../../entity/person.dart';
import '../../entity/user.dart';
import '../../repository/person_repository.dart';
import '../../service/coaching_request_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc
    extends BlocWithStatus<HomeEvent, HomeState, HomeBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;

  HomeBloc({
    HomeState state = const HomeState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        super(state) {
    on<HomeEventInitialize>(_initialize, transformer: restartable());
    on<HomeEventDeleteAcceptedCoachingRequests>(
      _deleteAcceptedCoachingRequests,
    );
    on<HomeEventSignOut>(_signOut);
  }

  Future<void> _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) async {
    emitLoadingStatus(emit);
    final Stream<(User?, List<Person>)> stream$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest2(
                _userRepository.getUserById(userId: loggedUserId),
                _getNewClients(loggedUserId),
                (loggedUserData, newClients) => (loggedUserData, newClients),
              ),
            );
    await emit.forEach(
      stream$,
      onData: ((User?, List<Person>) data) => state.copyWith(
        accountType: data.$1?.accountType,
        loggedUserName: data.$1?.name,
        appSettings: data.$1?.settings,
        newClients: data.$2,
      ),
    );
  }

  Future<void> _deleteAcceptedCoachingRequests(
    HomeEventDeleteAcceptedCoachingRequests event,
    Emitter<HomeState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId != null) {
      await _coachingRequestService.deleteAcceptedCoachingRequestsBySenderId(
        senderId: loggedUserId,
      );
    }
  }

  Future<void> _signOut(
    HomeEventSignOut event,
    Emitter<HomeState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _authService.signOut();
    emitCompleteStatus(emit, info: HomeBlocInfo.userSignedOut);
  }

  Stream<List<Person>> _getNewClients(String loggedUserId) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(senderId: loggedUserId)
          .map((requests) => requests.where((req) => req.isAccepted).toList())
          .map(
            (acceptedRequests) => acceptedRequests.map(
              (req) => _personRepository
                  .getPersonById(personId: req.receiverId)
                  .whereNotNull(),
            ),
          )
          .switchMap(
            (streams) => streams.isEmpty
                ? Stream.value([])
                : Rx.combineLatest(streams, (newClients) => newClients),
          );
}

enum HomeBlocInfo { userSignedOut }
