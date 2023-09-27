import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/coaching_request_short.dart';
import '../../entity/person.dart';
import '../../entity/user.dart';
import '../../repository/chat_repository.dart';
import '../../repository/message_repository.dart';
import '../../repository/person_repository.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final AuthService _authService;
  final CoachingRequestService _coachingRequestService;
  final UserRepository _userRepository;
  final PersonRepository _personRepository;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  StreamSubscription<NotificationsState>? _acceptedRequestsListener;
  StreamSubscription<NotificationsState>? _receivedRequestsListener;
  StreamSubscription<NotificationsState>? _awaitingMessagesListener;

  NotificationsCubit()
      : _authService = getIt<AuthService>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _userRepository = getIt<UserRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        super(const NotificationsState());

  @override
  Future<void> close() {
    _acceptedRequestsListener?.cancel();
    _receivedRequestsListener?.cancel();
    _awaitingMessagesListener?.cancel();
    return super.close();
  }

  void listenToAcceptedRequests() {
    _acceptedRequestsListener ??= _getLoggedUser().switchMap(
      (User? loggedUser) {
        return loggedUser == null
            ? Stream.value(state.copyWith())
            : Rx.combineLatest2(
                loggedUser.coachId == null
                    ? _getAcceptedCoachReq(loggedUser.id)
                    : Stream.value(null),
                loggedUser.accountType == AccountType.coach
                    ? _getAcceptedClientReqs(loggedUser.id)
                    : Stream.value(null),
                (
                  CoachingRequestShort? acceptedCoachReq,
                  List<CoachingRequestShort>? acceptedClientReqs,
                ) =>
                    state.copyWith(
                  acceptedClientRequests: acceptedClientReqs,
                  acceptedCoachRequest: acceptedCoachReq,
                ),
              );
      },
    ).listen(emit);
  }

  void listenToReceivedRequests() {
    _receivedRequestsListener ??= _getLoggedUser().switchMap(
      (User? loggedUser) {
        return loggedUser == null
            ? Stream.value(state.copyWith())
            : Rx.combineLatest2(
                loggedUser.coachId == null
                    ? _getNumberOfReqsFromCoaches(loggedUser.id)
                    : Stream.value(null),
                loggedUser.accountType == AccountType.coach
                    ? _getNumberOfReqsFromClients(loggedUser.id)
                    : Stream.value(null),
                (
                  int? numberOfReqsFromCoaches,
                  int? numberOfReqsFromClients,
                ) =>
                    state.copyWith(
                  numberOfCoachingRequestsFromCoaches: numberOfReqsFromCoaches,
                  numberOfCoachingRequestsFromClients: numberOfReqsFromClients,
                ),
              );
      },
    ).listen(emit);
  }

  void listenToAwaitingMessages() {
    _awaitingMessagesListener ??= _getLoggedUser().switchMap(
      (User? loggedUser) {
        return loggedUser == null
            ? Stream.value(state.copyWith())
            : Rx.combineLatest2(
                loggedUser.coachId != null
                    ? _hasLoggedUserUnreadMsgsFromSender(
                        loggedUser.id,
                        loggedUser.coachId!,
                      )
                    : Stream.value(null),
                loggedUser.accountType == AccountType.coach
                    ? _getIdsOfClientsWithAwaitingMsgs(loggedUser.id)
                    : Stream.value(null),
                (
                  bool? areThereUnreadMsgsFromCoach,
                  List<String>? idsOfClientsWithAwaitingMsgs,
                ) =>
                    state.copyWith(
                  areThereUnreadMessagesFromCoach: areThereUnreadMsgsFromCoach,
                  idsOfClientsWithAwaitingMessages:
                      idsOfClientsWithAwaitingMsgs,
                ),
              );
      },
    ).listen(emit);
  }

  Stream<User?> _getLoggedUser() => _authService.loggedUserId$.switchMap(
        (String? loggedUserId) => loggedUserId != null
            ? _userRepository.getUserById(userId: loggedUserId)
            : Stream.value(null),
      );

  Stream<CoachingRequestShort?> _getAcceptedCoachReq(String loggedUserId) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((reqs) => reqs.firstWhereOrNull((req) => req.isAccepted))
          .doOnData(
            (req) => req != null
                ? _userRepository.refreshUserById(userId: loggedUserId)
                : null,
          )
          .switchMap(
            (req) => req != null ? _shortenReq(req) : Stream.value(null),
          );

  Stream<List<CoachingRequestShort>> _getAcceptedClientReqs(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((reqs) => reqs.where((req) => req.isAccepted))
          .doOnData(
            (acceptedReqs) => acceptedReqs.isNotEmpty
                ? _personRepository.refreshPersonsByCoachId(
                    coachId: loggedUserId,
                  )
                : null,
          )
          .map((acceptedReqs) => acceptedReqs.map(_shortenReq))
          .switchMap(
            (acceptedReqs$) => acceptedReqs$.isEmpty
                ? Stream.value([])
                : Rx.combineLatest(acceptedReqs$, (reqs) => reqs),
          );

  Stream<int> _getNumberOfReqsFromCoaches(String loggedUserId) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((reqs) => reqs.where((req) => !req.isAccepted).length);

  Stream<int> _getNumberOfReqsFromClients(String loggedUserId) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((reqs) => reqs.where((req) => !req.isAccepted).length);

  Stream<bool> _hasLoggedUserUnreadMsgsFromSender(
    String loggedUserId,
    String senderId,
  ) =>
      Rx.fromCallable(
        () async => await _chatRepository.findChatIdByUsers(
          user1Id: loggedUserId,
          user2Id: senderId,
        ),
      ).switchMap(
        (String? chatId) => chatId == null
            ? Stream.value(false)
            : _messageRepository.doesUserHaveUnreadMessagesInChat(
                chatId: chatId,
                userId: loggedUserId,
              ),
      );

  Stream<List<String>> _getIdsOfClientsWithAwaitingMsgs(String loggedUserId) =>
      _personRepository.getPersonsByCoachId(coachId: loggedUserId).asyncMap(
        (List<Person>? clients) async {
          final List<Stream<String?>> idsOfClientsWithAwaitingMsgs = [];
          if (clients == null) return idsOfClientsWithAwaitingMsgs;
          for (final client in clients) {
            idsOfClientsWithAwaitingMsgs.add(
              _hasLoggedUserUnreadMsgsFromSender(loggedUserId, client.id)
                  .map((hasUnreadMsgs) => hasUnreadMsgs ? client.id : null),
            );
          }
          return idsOfClientsWithAwaitingMsgs;
        },
      ).switchMap(
        (List<Stream<String?>> ids$) => ids$.isEmpty
            ? Stream.value(const [])
            : Rx.combineLatest(ids$, (ids) => ids.whereType<String>().toList()),
      );

  Stream<CoachingRequestShort> _shortenReq(CoachingRequest request) =>
      Rx.combineLatest2(
        Stream.value(request.id),
        _personRepository
            .getPersonById(personId: request.receiverId)
            .whereNotNull(),
        (String reqId, Person receiver) =>
            CoachingRequestShort(id: reqId, personToDisplay: receiver),
      );
}
