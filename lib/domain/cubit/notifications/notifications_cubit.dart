import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
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
  StreamSubscription<NotificationsState>? _listener;

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
    _listener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (loggedUserId) => _userRepository.getUserById(userId: loggedUserId),
        )
        .whereNotNull()
        .switchMap(_createStreamsAdjustedToUser)
        .listen(emit);
  }

  Stream<NotificationsState> _createStreamsAdjustedToUser(User loggedUser) {
    Stream<List<String>?> idsOfClientsWithAwaitingMessages$ =
        Stream.value(null);
    Stream<bool?> areThereUnreadMessagesFromCoach$ = Stream.value(null);
    Stream<int?> numberOfCoachingRequestsReceivedFromClients$ =
        Stream.value(null);
    if (loggedUser.coachId != null) {
      areThereUnreadMessagesFromCoach$ = _hasLoggedUserUnreadMessagesFromSender(
        loggedUserId: loggedUser.id,
        senderId: loggedUser.coachId!,
      );
    }
    if (loggedUser.accountType == AccountType.coach) {
      idsOfClientsWithAwaitingMessages$ =
          _getIdsOfClientsWithAwaitingMessages(loggedUser.id);
      numberOfCoachingRequestsReceivedFromClients$ =
          _getNumberOfCoachingRequestsReceivedFromClients(loggedUser.id);
    }
    return Rx.combineLatest3(
      idsOfClientsWithAwaitingMessages$,
      areThereUnreadMessagesFromCoach$,
      numberOfCoachingRequestsReceivedFromClients$,
      (
        List<String>? idsOfClientsWithAwaitingMessages,
        bool? areThereUnreadMessagesFromCoach,
        int? numberOfCoachingRequestsReceivedFromClients,
      ) =>
          state.copyWith(
        idsOfClientsWithAwaitingMessages: idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach: areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsReceivedFromClients:
            numberOfCoachingRequestsReceivedFromClients,
      ),
    );
  }

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
}
