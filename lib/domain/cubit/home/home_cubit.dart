import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/cubit_status.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/coaching_request_short.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../additional_model/settings.dart';
import '../../entity/person.dart';
import '../../entity/user.dart';
import '../../repository/chat_repository.dart';
import '../../repository/message_repository.dart';
import '../../repository/person_repository.dart';
import '../../service/coaching_request_service.dart';

part 'home_state.dart';

class HomeCubit extends CubitWithStatus<HomeState, HomeCubitInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  StreamSubscription<_ListenedParams?>? _listener;

  HomeCubit({
    HomeState initialState = const HomeState(status: CubitStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  Future<void> initialize() async {
    emitLoadingStatus();
    _listener ??= _authService.loggedUserId$
        .switchMap(
          (String? loggedUserId) => loggedUserId != null
              ? Rx.combineLatest4(
                  _userRepository.getUserById(userId: loggedUserId),
                  _getAcceptedClientRequests(loggedUserId),
                  _getAcceptedCoachRequest(loggedUserId),
                  _getIdsOfClientsWithAwaitingMessages(loggedUserId),
                  (
                    User? loggedUserData,
                    List<CoachingRequestShort> acceptedClientRequests,
                    CoachingRequestShort? acceptedCoachRequest,
                    List<String> idsOfClientsWithAwaitingMessages,
                  ) =>
                      _ListenedParams(
                    loggedUserData: loggedUserData,
                    acceptedClientRequests: acceptedClientRequests,
                    acceptedCoachRequest: acceptedCoachRequest,
                    idsOfClientsWithAwaitingMessages:
                        idsOfClientsWithAwaitingMessages,
                  ),
                )
              : Stream.value(null),
        )
        .listen(
          (_ListenedParams? params) => emit(
            state.copyWith(
              status: params == null ? const CubitStatusNoLoggedUser() : null,
              accountType: params?.loggedUserData?.accountType,
              loggedUserName: params?.loggedUserData?.name,
              appSettings: params?.loggedUserData?.settings,
              acceptedClientRequests: params?.acceptedClientRequests,
              acceptedCoachRequest: params?.acceptedCoachRequest,
              idsOfClientsWithAwaitingMessages:
                  params?.idsOfClientsWithAwaitingMessages,
            ),
          ),
        );
  }

  Future<void> deleteCoachingRequest(String requestId) async {
    await _coachingRequestService.deleteCoachingRequest(requestId: requestId);
  }

  Future<void> signOut() async {
    emitLoadingStatus();
    await _authService.signOut();
    emitCompleteStatus(info: HomeCubitInfo.userSignedOut);
  }

  Stream<List<CoachingRequestShort>> _getAcceptedClientRequests(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((requests) => requests.where((req) => req.isAccepted))
          .doOnData(
            (acceptedReqs) => acceptedReqs.isNotEmpty
                ? _personRepository.refreshPersonsByCoachId(
                    coachId: loggedUserId,
                  )
                : null,
          )
          .map(
            (acceptedReqs) => acceptedReqs.map(_convertToCoachingRequestShort),
          )
          .switchMap(
            (streams) => streams.isEmpty
                ? Stream.value([])
                : Rx.combineLatest(
                    streams,
                    (acceptedClientRequests) => acceptedClientRequests,
                  ),
          );

  Stream<CoachingRequestShort?> _getAcceptedCoachRequest(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((requests) => requests.firstWhereOrNull((req) => req.isAccepted))
          .doOnData(
            (acceptedReq) => acceptedReq != null
                ? _userRepository.refreshUserById(userId: loggedUserId)
                : null,
          )
          .switchMap(
            (CoachingRequest? acceptedReq) => acceptedReq != null
                ? _convertToCoachingRequestShort(acceptedReq)
                : Stream.value(null),
          );

  Stream<List<String>> _getIdsOfClientsWithAwaitingMessages(
    String loggedUserId,
  ) =>
      _personRepository
          .getPersonsByCoachId(coachId: loggedUserId)
          .whereNotNull()
          .asyncMap(
        (List<Person> clients) async {
          final List<Stream<String?>> idsOfClientsWithAwaitingMessages = [];
          for (final client in clients) {
            final String? chatId = await _chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: client.id,
            );
            if (chatId != null) {
              idsOfClientsWithAwaitingMessages.add(
                _messageRepository
                    .doesUserHaveUnreadMessagesInChat(
                      chatId: chatId,
                      userId: loggedUserId,
                    )
                    .map((hasUnreadMsgs) => hasUnreadMsgs ? client.id : null),
              );
            }
          }
          return idsOfClientsWithAwaitingMessages;
        },
      ).switchMap(
        (idsOfClientsWithAwaitingMessages$) => Rx.combineLatest(
          idsOfClientsWithAwaitingMessages$,
          (values) => values.whereType<String>().toList(),
        ),
      );

  Stream<CoachingRequestShort> _convertToCoachingRequestShort(
    CoachingRequest request,
  ) =>
      Rx.combineLatest2(
        Stream.value(request.id),
        _personRepository
            .getPersonById(personId: request.receiverId)
            .whereNotNull(),
        (reqId, receiver) => CoachingRequestShort(
          id: reqId,
          personToDisplay: receiver,
        ),
      );
}

enum HomeCubitInfo { userSignedOut }

class _ListenedParams extends Equatable {
  final User? loggedUserData;
  final List<CoachingRequestShort> acceptedClientRequests;
  final CoachingRequestShort? acceptedCoachRequest;
  final List<String> idsOfClientsWithAwaitingMessages;

  const _ListenedParams({
    required this.loggedUserData,
    required this.acceptedClientRequests,
    required this.acceptedCoachRequest,
    required this.idsOfClientsWithAwaitingMessages,
  });

  @override
  List<Object?> get props => [
        loggedUserData,
        acceptedClientRequests,
        acceptedCoachRequest,
        idsOfClientsWithAwaitingMessages,
      ];
}
