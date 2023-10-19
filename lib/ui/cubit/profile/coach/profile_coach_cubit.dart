import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../../../../data/interface/service/auth_service.dart';
import '../../../../../../data/interface/service/coaching_request_service.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../../../domain/model/coaching_request_with_person.dart';
import '../../../../../../domain/use_case/delete_chat_use_case.dart';
import '../../../../../../domain/use_case/get_received_coaching_requests_with_sender_info_use_case.dart';
import '../../../../../../domain/use_case/get_sent_coaching_requests_with_receiver_info_use_case.dart';
import '../../../../../../domain/use_case/load_chat_id_use_case.dart';
import '../../../../data/model/person.dart';
import '../../../../data/model/user.dart';
import '../../../../data/repository/person/person_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../model/cubit_state.dart';
import '../../../model/cubit_status.dart';
import '../../../model/cubit_with_status.dart';

part 'profile_coach_state.dart';

class ProfileCoachCubit extends CubitWithStatus<ProfileCoachState,
    ProfileCoachCubitInfo, ProfileCoachCubitError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;
  final GetSentCoachingRequestsWithReceiverInfoUseCase
      _getSentCoachingRequestsWithReceiverInfoUseCase;
  final GetReceivedCoachingRequestsWithSenderInfoUseCase
      _getReceivedCoachingRequestsWithSenderInfoUseCase;
  final LoadChatIdUseCase _loadChatIdUseCase;
  final DeleteChatUseCase _deleteChatUseCase;
  StreamSubscription<ProfileCoachState>? _listener;

  ProfileCoachCubit({
    ProfileCoachState initialState = const ProfileCoachState(
      status: CubitStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _getSentCoachingRequestsWithReceiverInfoUseCase =
            getIt<GetSentCoachingRequestsWithReceiverInfoUseCase>(),
        _getReceivedCoachingRequestsWithSenderInfoUseCase =
            getIt<GetReceivedCoachingRequestsWithSenderInfoUseCase>(),
        _loadChatIdUseCase = getIt<LoadChatIdUseCase>(),
        _deleteChatUseCase = getIt<DeleteChatUseCase>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _getLoggedUser()
        .switchMap(
          (User loggedUser) => loggedUser.coachId != null
              ? _personRepository
                  .getPersonById(personId: loggedUser.coachId!)
                  .whereNotNull()
                  .map(
                    (Person coach) => state.copyWith(
                      coachId: coach.id,
                      coachFullName: '${coach.name} ${coach.surname}',
                      coachEmail: coach.email,
                      deletedRequests: true,
                    ),
                  )
              : Rx.combineLatest2(
                  _getSentCoachingRequests(loggedUser.id),
                  _getReceivedCoachingRequests(loggedUser.id),
                  (
                    List<CoachingRequestWithPerson> sentRequests,
                    List<CoachingRequestWithPerson> receivedRequests,
                  ) =>
                      state.copyWith(
                    sentRequests: sentRequests,
                    receivedRequests: receivedRequests,
                    deletedCoachParams: true,
                  ),
                ),
        )
        .listen(emit);
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
        .person
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
    emitLoadingStatus();
    final String? chatId = await _loadChatIdUseCase.execute(
      user1Id: loggedUserId,
      user2Id: coachId,
    );
    emitCompleteStatus();
    return chatId;
  }

  Future<void> deleteCoach() async {
    final String? coachId = state.coachId;
    if (coachId == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    await _userRepository.updateUser(userId: loggedUserId, coachIdAsNull: true);
    await _coachingRequestService.deleteCoachingRequestBetweenUsers(
      user1Id: loggedUserId,
      user2Id: coachId,
    );
    final String? chatId = await _loadChatIdUseCase.execute(
      user1Id: loggedUserId,
      user2Id: coachId,
    );
    if (chatId != null) await _deleteChatUseCase.execute(chatId: chatId);
    emitCompleteStatus(info: ProfileCoachCubitInfo.coachDeleted);
  }

  Future<bool> checkIfStillHasCoach() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return false;
    }
    await _userRepository.refreshUserById(userId: loggedUserId);
    final User? loggedUser =
        await _userRepository.getUserById(userId: loggedUserId).first;
    if (loggedUser?.coachId != null) {
      return true;
    }
    emitErrorStatus(ProfileCoachCubitError.userNoLongerHasCoach);
    return false;
  }

  Stream<User> _getLoggedUser() => _authService.loggedUserId$
      .whereNotNull()
      .switchMap(
        (loggedUserId) => _userRepository.getUserById(userId: loggedUserId),
      )
      .whereNotNull();

  Stream<List<CoachingRequestWithPerson>> _getSentCoachingRequests(
    String loggedUserId,
  ) =>
      _getSentCoachingRequestsWithReceiverInfoUseCase.execute(
        senderId: loggedUserId,
        requestDirection: CoachingRequestDirection.clientToCoach,
        requestStatuses: SentCoachingRequestStatuses.onlyUnaccepted,
      );

  Stream<List<CoachingRequestWithPerson>> _getReceivedCoachingRequests(
    String loggedUserId,
  ) =>
      _getReceivedCoachingRequestsWithSenderInfoUseCase.execute(
        receiverId: loggedUserId,
        requestDirection: CoachingRequestDirection.coachToClient,
        requestStatuses: ReceivedCoachingRequestStatuses.onlyUnaccepted,
      );
}

enum ProfileCoachCubitInfo {
  requestAccepted,
  requestDeleted,
  requestUndid,
  coachDeleted
}

enum ProfileCoachCubitError { userNoLongerHasCoach }
