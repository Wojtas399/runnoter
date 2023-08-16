import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../dependency_injection.dart';
import '../../../additional_model/bloc_state.dart';
import '../../../additional_model/bloc_status.dart';
import '../../../additional_model/bloc_with_status.dart';
import '../../../additional_model/coaching_request.dart';
import '../../../additional_model/coaching_request_short.dart';
import '../../../entity/person.dart';
import '../../../entity/user.dart';
import '../../../repository/person_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../service/auth_service.dart';
import '../../../service/coaching_request_service.dart';

part 'profile_coach_event.dart';
part 'profile_coach_state.dart';

class ProfileCoachBloc extends BlocWithStatus<ProfileCoachEvent,
    ProfileCoachState, ProfileCoachBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;
  StreamSubscription<
          (List<CoachingRequestShort>?, List<CoachingRequestShort>?)>?
      _requestsListener;

  ProfileCoachBloc({
    ProfileCoachState state = const ProfileCoachState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(state) {
    on<ProfileCoachEventInitializeCoachListener>(
      _initializeCoachListener,
      transformer: restartable(),
    );
    on<ProfileCoachEventInitializeRequestsListener>(
      _initializeRequestsListener,
      transformer: restartable(),
    );
    on<ProfileCoachEventRemoveRequestsListener>(_removeRequestsListener);
    on<ProfileCoachEventRequestsUpdated>(_requestsUpdated);
    on<ProfileCoachEventAcceptRequest>(_acceptRequest);
    on<ProfileCoachEventDeleteRequest>(_deleteRequest);
    on<ProfileCoachEventDeleteCoach>(_deleteCoach);
  }

  @override
  Future<void> close() {
    _requestsListener?.cancel();
    _requestsListener = null;
    return super.close();
  }

  Future<void> _initializeCoachListener(
    ProfileCoachEventInitializeCoachListener event,
    Emitter<ProfileCoachState> emit,
  ) async {
    await emit.forEach(
      _getCoach(),
      onData: (Person? coach) {
        if (coach == null) {
          add(const ProfileCoachEventInitializeRequestsListener());
        } else {
          add(const ProfileCoachEventRemoveRequestsListener());
        }
        return state.copyWith(coach: coach, setCoachAsNull: coach == null);
      },
    );
  }

  void _initializeRequestsListener(
    ProfileCoachEventInitializeRequestsListener event,
    Emitter<ProfileCoachState> emit,
  ) {
    _requestsListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(_getSentAndReceivedCoachingRequests)
        .listen(
          (requests) => add(ProfileCoachEventRequestsUpdated(
            sentRequests: requests.$1,
            receivedRequests: requests.$2,
          )),
        );
  }

  void _removeRequestsListener(
    ProfileCoachEventRemoveRequestsListener event,
    Emitter<ProfileCoachState> emit,
  ) {
    _requestsListener?.cancel();
    _requestsListener = null;
  }

  void _requestsUpdated(
    ProfileCoachEventRequestsUpdated event,
    Emitter<ProfileCoachState> emit,
  ) {
    emit(state.copyWith(
      sentRequests: event.sentRequests,
      receivedRequests: event.receivedRequests,
    ));
  }

  Future<void> _acceptRequest(
    ProfileCoachEventAcceptRequest event,
    Emitter<ProfileCoachState> emit,
  ) async {
    if (state.receivedRequests == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    final String senderId = state.receivedRequests!
        .firstWhere((request) => request.id == event.requestId)
        .personToDisplay
        .id;
    await _userRepository.updateUser(userId: loggedUserId, coachId: senderId);
    await _coachingRequestService.updateCoachingRequest(
      requestId: event.requestId,
      isAccepted: true,
    );
    await _coachingRequestService.deleteUnacceptedCoachingRequestsByReceiverId(
      receiverId: loggedUserId,
    );
    emitCompleteStatus(emit, info: ProfileCoachBlocInfo.requestAccepted);
  }

  Future<void> _deleteRequest(
    ProfileCoachEventDeleteRequest event,
    Emitter<ProfileCoachState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _coachingRequestService.deleteCoachingRequest(
      requestId: event.requestId,
    );
    emitCompleteStatus(
      emit,
      info: switch (event.requestDirection) {
        CoachingRequestDirection.clientToCoach =>
          ProfileCoachBlocInfo.requestUndid,
        CoachingRequestDirection.coachToClient =>
          ProfileCoachBlocInfo.requestDeleted,
      },
    );
  }

  Future<void> _deleteCoach(
    ProfileCoachEventDeleteCoach event,
    Emitter<ProfileCoachState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUser(userId: loggedUserId, coachIdAsNull: true);
    emitCompleteStatus(emit, info: ProfileCoachBlocInfo.coachDeleted);
  }

  Stream<Person?> _getCoach() => _authService.loggedUserId$
      .whereNotNull()
      .switchMap(
        (loggedUserId) => _userRepository.getUserById(userId: loggedUserId),
      )
      .whereNotNull()
      .map((User loggedUser) => loggedUser.coachId)
      .switchMap(
        (coachId) => coachId != null
            ? _personRepository.getPersonById(personId: coachId)
            : Stream.value(null),
      );

  Stream<(List<CoachingRequestShort>?, List<CoachingRequestShort>?)>
      _getSentAndReceivedCoachingRequests(String loggedUserId) =>
          Rx.combineLatest2(
            _getSentCoachingRequests(loggedUserId),
            _getReceivedCoachingRequests(loggedUserId),
            (sentReqs, receivedReqs) => (sentReqs, receivedReqs),
          );

  Stream<List<CoachingRequestShort>?> _getSentCoachingRequests(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((requests) => requests.where((req) => !req.isAccepted))
          .map(_combineCoachingRequestIdsWithReceiversInfo)
          .switchMap(_switchToStreamWithRequestsDetails);

  Stream<List<CoachingRequestShort>?> _getReceivedCoachingRequests(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((requests) => requests.where((request) => !request.isAccepted))
          .map(_combineCoachingRequestIdsWithSendersInfo)
          .switchMap(_switchToStreamWithRequestsDetails);

  List<Stream<(String, Person)>>? _combineCoachingRequestIdsWithReceiversInfo(
    Iterable<CoachingRequest> coachingRequests,
  ) =>
      coachingRequests.isEmpty
          ? []
          : coachingRequests
              .map(
                (CoachingRequest request) => Rx.combineLatest2(
                  Stream.value(request.id),
                  _personRepository
                      .getPersonById(personId: request.receiverId)
                      .whereNotNull(),
                  (requestId, senderInfo) => (requestId, senderInfo),
                ),
              )
              .toList();

  List<Stream<(String, Person)>>? _combineCoachingRequestIdsWithSendersInfo(
    Iterable<CoachingRequest> coachingRequests,
  ) =>
      coachingRequests.isEmpty
          ? []
          : coachingRequests
              .map(
                (CoachingRequest request) => Rx.combineLatest2(
                  Stream.value(request.id),
                  _personRepository
                      .getPersonById(personId: request.senderId)
                      .whereNotNull(),
                  (requestId, senderInfo) => (requestId, senderInfo),
                ),
              )
              .toList();

  Stream<List<CoachingRequestShort>?> _switchToStreamWithRequestsDetails(
    List<Stream<(String, Person)>>? streams,
  ) =>
      streams == null || streams.isEmpty == true
          ? Stream.value([])
          : Rx.combineLatest(
              streams,
              (List<(String, Person)> values) => values
                  .map(
                    ((String, Person) data) => CoachingRequestShort(
                      id: data.$1,
                      personToDisplay: data.$2,
                    ),
                  )
                  .toList(),
            );
}

enum ProfileCoachBlocInfo {
  requestAccepted,
  requestDeleted,
  requestUndid,
  coachDeleted,
}
