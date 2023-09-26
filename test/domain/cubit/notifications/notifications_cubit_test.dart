import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/cubit/notifications/notifications_cubit.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';
import 'package:runnoter/domain/repository/message_repository.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_chat_repository.dart';
import '../../../mock/domain/repository/mock_message_repository.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final coachingRequestService = MockCoachingRequestService();
  final userRepository = MockUserRepository();
  final personRepository = MockPersonRepository();
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerSingleton<ChatRepository>(chatRepository);
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
  });

  tearDown(() {
    reset(authService);
    reset(coachingRequestService);
    reset(userRepository);
    reset(personRepository);
    reset(chatRepository);
    reset(messageRepository);
  });

  group(
    'initialize, '
    'logged user is not a coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
      );
      final User updatedLoggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        coachId: 'c1',
      );
      const String coachChatId = 'chat1';
      final StreamController<User> loggedUser$ = StreamController()
        ..add(loggedUser);
      final StreamController<bool> doesUserHaveUnreadMessagesInCoachChat$ =
          BehaviorSubject.seeded(false);

      blocTest(
        'should only listen to unread messages in coach chat',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(userStream: loggedUser$.stream);
          chatRepository.mockFindChatIdForUsers(chatId: coachChatId);
          messageRepository.mockDoesUserHaveUnreadMessagesInChat(
            expected$: doesUserHaveUnreadMessagesInCoachChat$.stream,
          );
        },
        act: (cubit) {
          cubit.initialize();
          loggedUser$.add(updatedLoggedUser);
          doesUserHaveUnreadMessagesInCoachChat$.add(true);
        },
        expect: () => [
          const NotificationsState(),
          const NotificationsState(
            areThereUnreadMessagesFromCoach: true,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'c1',
            ),
          ).called(1);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: coachChatId,
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'initialize, '
    'logged user is a coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
      );
      final User updatedLoggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
        coachId: 'c1',
      );
      final List<Person> clients = [createPerson(id: 'p1')];
      final List<Person> updatedClients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
      ];
      final List<CoachingRequest> requestsReceivedFromClients = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: true),
      ];
      final List<CoachingRequest> updatedRequestsReceivedFromClients = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: true),
        createCoachingRequest(id: 'r4', isAccepted: false),
        createCoachingRequest(id: 'r5', isAccepted: false),
      ];
      final StreamController<User> loggedUser$ = StreamController()
        ..add(loggedUser);
      final StreamController<List<Person>> clients$ =
          BehaviorSubject.seeded(clients);
      final StreamController<bool> doesUserHaveUnreadMessagesInClient1Chat$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMessagesInClient2Chat$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMessagesInCoachChat$ =
          BehaviorSubject.seeded(false);
      StreamController<List<CoachingRequest>> requestsReceivedFromClients$ =
          BehaviorSubject.seeded(requestsReceivedFromClients);

      blocTest(
        'should listen to ids of clients with awaiting messages, '
        'should listen whether there are unread messages from coach, '
        'should listen to number of unaccepted requests received from clients',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(userStream: loggedUser$.stream);
          personRepository.mockGetPersonsByCoachId(
            personsStream: clients$.stream,
          );
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p1',
            ),
          ).thenAnswer((_) => Future.value('chat1'));
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p2',
            ),
          ).thenAnswer((_) => Future.value('chat2'));
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'c1',
            ),
          ).thenAnswer((_) => Future.value('coachChat'));
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat1',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMessagesInClient1Chat$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat2',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMessagesInClient2Chat$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'coachChat',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMessagesInCoachChat$.stream);
          coachingRequestService.mockGetCoachingRequestsByReceiverId(
            requestsStream: requestsReceivedFromClients$.stream,
          );
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          loggedUser$.add(updatedLoggedUser);
          doesUserHaveUnreadMessagesInCoachChat$.add(true);
          await cubit.stream.first;
          doesUserHaveUnreadMessagesInClient1Chat$.add(true);
          await cubit.stream.first;
          clients$.add(updatedClients);
          requestsReceivedFromClients$.add(updatedRequestsReceivedFromClients);
          await cubit.stream.first;
          doesUserHaveUnreadMessagesInClient2Chat$.add(true);
          await cubit.stream.first;
          doesUserHaveUnreadMessagesInCoachChat$.add(false);
          await cubit.stream.first;
          doesUserHaveUnreadMessagesInClient1Chat$.add(false);
        },
        expect: () => [
          const NotificationsState(
            numberOfCoachingRequestsReceivedFromClients: 1,
          ),
          const NotificationsState(
            areThereUnreadMessagesFromCoach: true,
            numberOfCoachingRequestsReceivedFromClients: 1,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p1'],
            areThereUnreadMessagesFromCoach: true,
            numberOfCoachingRequestsReceivedFromClients: 1,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p1'],
            areThereUnreadMessagesFromCoach: true,
            numberOfCoachingRequestsReceivedFromClients: 3,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p1', 'p2'],
            areThereUnreadMessagesFromCoach: true,
            numberOfCoachingRequestsReceivedFromClients: 3,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p1', 'p2'],
            areThereUnreadMessagesFromCoach: false,
            numberOfCoachingRequestsReceivedFromClients: 3,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p2'],
            areThereUnreadMessagesFromCoach: false,
            numberOfCoachingRequestsReceivedFromClients: 3,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
          ).called(2);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p1',
            ),
          ).called(3);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p2',
            ),
          ).called(1);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'c1',
            ),
          ).called(1);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat1',
              userId: loggedUserId,
            ),
          ).called(3);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat2',
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'coachChat',
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(2);
        },
      );
    },
  );
}
