import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/coaching_request.dart';
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
    final Stream<HomeBlocListenedParams?> stream$ =
        _authService.loggedUserId$.switchMap(
      (String? loggedUserId) => loggedUserId != null
          ? Rx.combineLatest3(
              _userRepository.getUserById(userId: loggedUserId),
              _getNewClients(loggedUserId),
              _getNewCoach(loggedUserId),
              (
                User? loggedUserData,
                List<Person> newClients,
                Person? newCoach,
              ) =>
                  HomeBlocListenedParams(
                loggedUserData: loggedUserData,
                newClients: newClients,
                newCoach: newCoach,
              ),
            )
          : Stream.value(null),
    );
    await emit.forEach(
      stream$,
      onData: (HomeBlocListenedParams? params) => state.copyWith(
        status: params == null ? const BlocStatusNoLoggedUser() : null,
        accountType: params?.loggedUserData?.accountType,
        loggedUserName: params?.loggedUserData?.name,
        appSettings: params?.loggedUserData?.settings,
        newClients: params?.newClients,
        newCoach: params?.newCoach,
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
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((requests) => requests.where((req) => req.isAccepted))
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

  Stream<Person?> _getNewCoach(String loggedUserId) => _coachingRequestService
      .getCoachingRequestsBySenderId(
        senderId: loggedUserId,
        direction: CoachingRequestDirection.clientToCoach,
      )
      .map((requests) => requests.firstWhereOrNull((req) => req.isAccepted))
      .switchMap(
        (CoachingRequest? acceptedReq) => acceptedReq != null
            ? _personRepository.getPersonById(personId: acceptedReq.receiverId)
            : Stream.value(null),
      );
}

enum HomeBlocInfo { userSignedOut }

class HomeBlocListenedParams extends Equatable {
  final User? loggedUserData;
  final List<Person> newClients;
  final Person? newCoach;

  const HomeBlocListenedParams({
    required this.loggedUserData,
    required this.newClients,
    required this.newCoach,
  });

  @override
  List<Object?> get props => [loggedUserData, newClients, newCoach];
}
