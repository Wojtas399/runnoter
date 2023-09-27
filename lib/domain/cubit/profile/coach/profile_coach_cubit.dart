import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../../dependency_injection.dart';
import '../../../additional_model/coaching_request.dart';
import '../../../additional_model/coaching_request_short.dart';
import '../../../additional_model/cubit_state.dart';
import '../../../additional_model/cubit_status.dart';
import '../../../additional_model/cubit_with_status.dart';
import '../../../entity/person.dart';
import '../../../entity/user.dart';
import '../../../repository/person_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../service/auth_service.dart';
import '../../../service/coaching_request_service.dart';
import '../../../use_case/load_chat_id_use_case.dart';

part 'profile_coach_state.dart';

class ProfileCoachCubit
    extends CubitWithStatus<ProfileCoachState, ProfileCoachCubitInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;
  final LoadChatIdUseCase _loadChatIdUseCase;
  StreamSubscription<Person?>? _coachListener;
  StreamSubscription<ProfileCoachState>? _requestsListener;

  ProfileCoachCubit({
    ProfileCoachState initialState = const ProfileCoachState(
      status: CubitStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _loadChatIdUseCase = getIt<LoadChatIdUseCase>(),
        super(initialState);

  @override
  Future<void> close() {
    _coachListener?.cancel();
    _requestsListener?.cancel();
    return super.close();
  }

  Future<void> initializeCoachListener() async {
    _coachListener ??= _getCoach().listen((Person? coach) {
      if (coach == null) {
        initializeRequestsListener();
      } else {
        removeRequestsListener();
      }
      emit(state.copyWith(
        coachId: coach?.id,
        coachFullName: coach != null ? '${coach.name} ${coach.surname}' : null,
        coachEmail: coach?.email,
        deletedCoachParams: coach == null,
      ));
    });
  }

  void initializeRequestsListener() {
    _requestsListener ??= _authService.loggedUserId$
        .switchMap(
          (String? loggedUserId) => loggedUserId == null
              ? Stream.value(state.copyWith())
              : Rx.combineLatest2(
                  _getSentCoachingRequests(loggedUserId),
                  _getReceivedCoachingRequests(loggedUserId),
                  (sentRequests, receivedRequests) => state.copyWith(
                    sentRequests: sentRequests,
                    receivedRequests: receivedRequests,
                  ),
                ),
        )
        .listen(emit);
  }

  void removeRequestsListener() {
    _requestsListener?.cancel();
    _requestsListener = null;
  }

  Future<void> acceptRequest(String requestId) async {
    if (state.receivedRequests == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    final String senderId = state.receivedRequests!
        .firstWhere((request) => request.id == requestId)
        .personToDisplay
        .id;
    await _userRepository.updateUser(userId: loggedUserId, coachId: senderId);
    await _coachingRequestService.updateCoachingRequest(
      requestId: requestId,
      isAccepted: true,
    );
    emitCompleteStatus(info: ProfileCoachCubitInfo.requestAccepted);
  }

  Future<void> deleteRequest({
    required String requestId,
    required CoachingRequestDirection requestDirection,
  }) async {
    emitLoadingStatus();
    await _coachingRequestService.deleteCoachingRequest(requestId: requestId);
    emitCompleteStatus(
      info: switch (requestDirection) {
        CoachingRequestDirection.clientToCoach =>
          ProfileCoachCubitInfo.requestUndid,
        CoachingRequestDirection.coachToClient =>
          ProfileCoachCubitInfo.requestDeleted,
      },
    );
  }

  Future<String?> loadChatId() async {
    final String? coachId = state.coachId;
    if (coachId == null) return null;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return null;
    return await _loadChatIdUseCase.execute(
      user1Id: loggedUserId,
      user2Id: coachId,
    );
  }

  Future<void> deleteCoach() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    await _userRepository.updateUser(userId: loggedUserId, coachIdAsNull: true);
    emitCompleteStatus(info: ProfileCoachCubitInfo.coachDeleted);
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

enum ProfileCoachCubitInfo {
  requestAccepted,
  requestDeleted,
  requestUndid,
  coachDeleted
}
