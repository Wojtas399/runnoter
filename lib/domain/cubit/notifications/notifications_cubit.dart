import 'dart:async';

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
  StreamSubscription<NotificationsState?>? _listener;

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
    _listener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _listener ??= _authService.loggedUserId$.switchMap(
      (String? loggedUserId) {
        return loggedUserId != null
            ? _userRepository.getUserById(userId: loggedUserId)
            : Stream.value(null);
      },
    ).switchMap(
      (User? loggedUser) {
        return loggedUser != null
            ? Rx.combineLatest2(
                _createCoachListenedParams(loggedUser),
                _createClientsListenedParams(loggedUser),
                (
                  _CoachListenedParams coachParams,
                  _ClientsListenedParams? clientsParams,
                ) =>
                    state.copyWith(
                  idsOfClientsWithAwaitingMessages:
                      clientsParams?.idsOfClientsWithAwaitingMessages,
                  areThereUnreadMessagesFromCoach:
                      coachParams.areThereUnreadMessagesFromCoach,
                  numberOfCoachingRequestsReceivedFromClients: clientsParams
                      ?.numberOfCoachingRequestsReceivedFromClients,
                  numberOfCoachingRequestsReceivedFromCoaches:
                      coachParams.numberOfCoachingRequestsReceivedFromCoaches,
                ),
              )
            : Stream.value(null);
      },
    ).listen(
      (NotificationsState? state) {
        if (state != null) emit(state);
      },
    );
  }

  Stream<_CoachListenedParams> _createCoachListenedParams(User loggedUser) =>
      loggedUser.coachId != null
          ? _hasLoggedUserUnreadMessagesFromSender(
              loggedUserId: loggedUser.id,
              senderId: loggedUser.coachId!,
            ).map(
              (bool val) =>
                  _CoachListenedParams(areThereUnreadMessagesFromCoach: val),
            )
          : _getNumberOfCoachingRequestsReceivedFromCoaches(loggedUser.id).map(
              (int val) => _CoachListenedParams(
                numberOfCoachingRequestsReceivedFromCoaches: val,
              ),
            );

  Stream<_ClientsListenedParams?> _createClientsListenedParams(
    User loggedUser,
  ) =>
      loggedUser.accountType == AccountType.coach
          ? Rx.combineLatest2(
              _getIdsOfClientsWithAwaitingMessages(loggedUser.id),
              _getNumberOfCoachingRequestsReceivedFromClients(loggedUser.id),
              (
                List<String> idsOfClientsWithAwaitingMessages,
                int numberOfCoachingRequestsReceivedFromClients,
              ) =>
                  _ClientsListenedParams(
                idsOfClientsWithAwaitingMessages:
                    idsOfClientsWithAwaitingMessages,
                numberOfCoachingRequestsReceivedFromClients:
                    numberOfCoachingRequestsReceivedFromClients,
              ),
            )
          : Stream.value(null);

  Stream<int> _getNumberOfCoachingRequestsReceivedFromCoaches(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((requests) => requests.where((req) => !req.isAccepted).length);

  Stream<bool> _hasLoggedUserUnreadMessagesFromSender({
    required String loggedUserId,
    required String senderId,
  }) =>
      Rx.fromCallable(
        () async => await _chatRepository.findChatIdByUsers(
          user1Id: loggedUserId,
          user2Id: senderId,
        ),
      ).switchMap(
        (String? coachChatId) => coachChatId == null
            ? Stream.value(false)
            : _messageRepository.doesUserHaveUnreadMessagesInChat(
                chatId: coachChatId,
                userId: loggedUserId,
              ),
      );

  Stream<List<String>> _getIdsOfClientsWithAwaitingMessages(
    String loggedUserId,
  ) =>
      _personRepository.getPersonsByCoachId(coachId: loggedUserId).asyncMap(
        (List<Person>? clients) async {
          final List<Stream<String?>> idsOfClientsWithAwaitingMessages = [];
          if (clients == null) return idsOfClientsWithAwaitingMessages;
          for (final client in clients) {
            idsOfClientsWithAwaitingMessages.add(
              _hasLoggedUserUnreadMessagesFromSender(
                loggedUserId: loggedUserId,
                senderId: client.id,
              ).map((hasUnreadMsgs) => hasUnreadMsgs ? client.id : null),
            );
          }
          return idsOfClientsWithAwaitingMessages;
        },
      ).switchMap(
        (List<Stream<String?>> idsOfClientsWithAwaitingMessages) =>
            idsOfClientsWithAwaitingMessages.isEmpty
                ? Stream.value(const [])
                : Rx.combineLatest(
                    idsOfClientsWithAwaitingMessages,
                    (values) => values.whereType<String>().toList(),
                  ),
      );

  Stream<int> _getNumberOfCoachingRequestsReceivedFromClients(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((requests) => requests.where((req) => !req.isAccepted).length);
}

class _CoachListenedParams extends Equatable {
  final bool areThereUnreadMessagesFromCoach;
  final int numberOfCoachingRequestsReceivedFromCoaches;

  const _CoachListenedParams({
    this.areThereUnreadMessagesFromCoach = false,
    this.numberOfCoachingRequestsReceivedFromCoaches = 0,
  });

  @override
  List<Object?> get props => [
        areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsReceivedFromCoaches,
      ];
}

class _ClientsListenedParams extends Equatable {
  final List<String> idsOfClientsWithAwaitingMessages;
  final int numberOfCoachingRequestsReceivedFromClients;

  const _ClientsListenedParams({
    required this.idsOfClientsWithAwaitingMessages,
    required this.numberOfCoachingRequestsReceivedFromClients,
  });

  @override
  List<Object?> get props => [
        idsOfClientsWithAwaitingMessages,
        numberOfCoachingRequestsReceivedFromClients,
      ];
}
