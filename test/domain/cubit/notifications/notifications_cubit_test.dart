import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
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
    'listenToAcceptedRequests, '
    'logged user is not a coach and has own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        coachId: 'c1',
      );

      blocTest(
        'should not listen to any requests',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
        },
        act: (cubit) => cubit.listenToAcceptedRequests(),
        expect: () => [
          const NotificationsState(),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToAcceptedRequests, '
    'logged user is not a coach and does not have own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
      );
      final Person coach = createPerson(id: 'co1', name: 'coach');
      final List<CoachingRequest> requestsSentToCoaches = [
        createCoachingRequest(id: 'r4', receiverId: 'co1', isAccepted: true),
      ];
      final List<CoachingRequest> updatedRequestsSentToCoaches = [
        createCoachingRequest(id: 'r5', receiverId: 'co2', isAccepted: false),
      ];
      final StreamController<List<CoachingRequest>> coachesRequests$ =
          StreamController()..add(requestsSentToCoaches);

      blocTest(
        'should only listen to accepted coach request',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
          userRepository.mockRefreshUserById();
          when(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).thenAnswer((_) => coachesRequests$.stream);
          when(
            () => personRepository.getPersonById(personId: coach.id),
          ).thenAnswer((_) => Stream.value(coach));
        },
        act: (cubit) async {
          cubit.listenToAcceptedRequests();
          await cubit.stream.first;
          coachesRequests$.add(updatedRequestsSentToCoaches);
        },
        expect: () => [
          NotificationsState(
            acceptedCoachRequest: CoachingRequestShort(
              id: 'r4',
              personToDisplay: coach,
            ),
          ),
          const NotificationsState(acceptedCoachRequest: null),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
          verify(
            () => userRepository.refreshUserById(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToAcceptedRequests, '
    'logged user is a coach and has own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
        coachId: 'c1',
      );
      final Person client1 = createPerson(id: 'cl1', name: 'first client');
      final Person client2 = createPerson(id: 'cl2', name: 'second client');
      final List<CoachingRequest> requestsSentToClients = [
        createCoachingRequest(id: 'r1', receiverId: 'cl3', isAccepted: false),
        createCoachingRequest(id: 'r2', receiverId: 'cl1', isAccepted: true),
      ];
      final List<CoachingRequest> updatedRequestsSentToClients = [
        createCoachingRequest(id: 'r3', receiverId: 'cl2', isAccepted: true),
      ];
      final StreamController<List<CoachingRequest>> clientsRequests$ =
          StreamController()..add(requestsSentToClients);

      blocTest(
        'should only listen to accepted client requests',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
          personRepository.mockRefreshPersonsByCoachId();
          when(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).thenAnswer((_) => clientsRequests$.stream);
          when(
            () => personRepository.getPersonById(personId: client1.id),
          ).thenAnswer((_) => Stream.value(client1));
          when(
            () => personRepository.getPersonById(personId: client2.id),
          ).thenAnswer((_) => Stream.value(client2));
        },
        act: (cubit) async {
          cubit.listenToAcceptedRequests();
          await cubit.stream.first;
          clientsRequests$.add(updatedRequestsSentToClients);
          await cubit.stream.first;
          clientsRequests$.add([]);
        },
        expect: () => [
          NotificationsState(
            acceptedClientRequests: [
              CoachingRequestShort(id: 'r2', personToDisplay: client1),
            ],
          ),
          NotificationsState(
            acceptedClientRequests: [
              CoachingRequestShort(id: 'r3', personToDisplay: client2),
            ],
          ),
          const NotificationsState(acceptedClientRequests: []),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
          verify(
            () => personRepository.refreshPersonsByCoachId(
              coachId: loggedUserId,
            ),
          ).called(2);
        },
      );
    },
  );

  group(
    'listenToAcceptedRequests, '
    'logged user is a coach and does not have own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
      );
      final Person client1 = createPerson(id: 'cl1', name: 'first client');
      final Person client2 = createPerson(id: 'cl2', name: 'second client');
      final Person coach = createPerson(id: 'co1', name: 'coach');
      final List<CoachingRequest> requestsSentToClients = [
        createCoachingRequest(id: 'r1', receiverId: 'cl3', isAccepted: false),
        createCoachingRequest(id: 'r2', receiverId: 'cl1', isAccepted: true),
      ];
      final List<CoachingRequest> updatedRequestsSentToClients = [
        createCoachingRequest(id: 'r3', receiverId: 'cl2', isAccepted: true),
      ];
      final List<CoachingRequest> requestsSentToCoaches = [
        createCoachingRequest(id: 'r4', receiverId: 'co1', isAccepted: true),
      ];
      final List<CoachingRequest> updatedRequestsSentToCoaches = [
        createCoachingRequest(id: 'r5', receiverId: 'co2', isAccepted: false),
      ];
      final StreamController<List<CoachingRequest>> clientsRequests$ =
          StreamController()..add(requestsSentToClients);
      final StreamController<List<CoachingRequest>> coachesRequests$ =
          StreamController()..add(requestsSentToCoaches);

      blocTest(
        'should listen to accepted client requests and coach request',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
          personRepository.mockRefreshPersonsByCoachId();
          userRepository.mockRefreshUserById();
          when(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).thenAnswer((_) => clientsRequests$.stream);
          when(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).thenAnswer((_) => coachesRequests$.stream);
          when(
            () => personRepository.getPersonById(personId: client1.id),
          ).thenAnswer((_) => Stream.value(client1));
          when(
            () => personRepository.getPersonById(personId: client2.id),
          ).thenAnswer((_) => Stream.value(client2));
          when(
            () => personRepository.getPersonById(personId: coach.id),
          ).thenAnswer((_) => Stream.value(coach));
        },
        act: (cubit) async {
          cubit.listenToAcceptedRequests();
          await cubit.stream.first;
          coachesRequests$.add(updatedRequestsSentToCoaches);
          clientsRequests$.add(updatedRequestsSentToClients);
        },
        expect: () => [
          NotificationsState(
            acceptedClientRequests: [
              CoachingRequestShort(id: 'r2', personToDisplay: client1),
            ],
            acceptedCoachRequest: CoachingRequestShort(
              id: 'r4',
              personToDisplay: coach,
            ),
          ),
          NotificationsState(
            acceptedClientRequests: [
              CoachingRequestShort(id: 'r2', personToDisplay: client1),
            ],
          ),
          NotificationsState(
            acceptedClientRequests: [
              CoachingRequestShort(id: 'r3', personToDisplay: client2),
            ],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
          verify(
            () => userRepository.refreshUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.refreshPersonsByCoachId(
              coachId: loggedUserId,
            ),
          ).called(2);
        },
      );
    },
  );

  group(
    'listenToReceivedRequests, '
    'user is not a coach and has own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        coachId: 'c1',
      );

      blocTest(
        'should not listen to any requests',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
        },
        act: (cubit) => cubit.listenToReceivedRequests(),
        expect: () => [
          const NotificationsState(),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToReceivedRequests, '
    'user is not a coach and does not have own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
      );
      final List<CoachingRequest> requestsReceivedFromCoaches = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: false),
      ];
      final List<CoachingRequest> updatedReqsFromCoaches = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: false),
        createCoachingRequest(id: 'r4', isAccepted: false),
        createCoachingRequest(id: 'r5', isAccepted: false),
      ];
      final StreamController<List<CoachingRequest>>
          requestsReceivedFromCoaches$ = StreamController()
            ..add(requestsReceivedFromCoaches);

      blocTest(
        'should only listen to number of coaching requests received from coaches',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
          when(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).thenAnswer((_) => requestsReceivedFromCoaches$.stream);
        },
        act: (cubit) async {
          cubit.listenToReceivedRequests();
          await cubit.stream.first;
          requestsReceivedFromCoaches$.add(updatedReqsFromCoaches);
        },
        expect: () => [
          const NotificationsState(
            numberOfCoachingRequestsFromCoaches: 2,
          ),
          const NotificationsState(
            numberOfCoachingRequestsFromCoaches: 4,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToReceivedRequests, '
    'user is a coach and has own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
        coachId: 'c1',
      );
      final List<CoachingRequest> requestsReceivedFromClients = [
        createCoachingRequest(id: 'r11', isAccepted: false),
        createCoachingRequest(id: 'r12', isAccepted: true),
        createCoachingRequest(id: 'r13', isAccepted: true),
      ];
      final List<CoachingRequest> updatedReqsFromClients = [
        createCoachingRequest(id: 'r11', isAccepted: false),
        createCoachingRequest(id: 'r12', isAccepted: true),
        createCoachingRequest(id: 'r13', isAccepted: true),
        createCoachingRequest(id: 'r14', isAccepted: false),
        createCoachingRequest(id: 'r15', isAccepted: false),
      ];
      final StreamController<List<CoachingRequest>>
          requestsReceivedFromClients$ = StreamController()
            ..add(requestsReceivedFromClients);

      blocTest(
        'should only listen to number of coaching requests received from clients',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
          when(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).thenAnswer((_) => requestsReceivedFromClients$.stream);
        },
        act: (cubit) async {
          cubit.listenToReceivedRequests();
          await cubit.stream.first;
          requestsReceivedFromClients$.add(updatedReqsFromClients);
        },
        expect: () => [
          const NotificationsState(
            numberOfCoachingRequestsFromClients: 1,
          ),
          const NotificationsState(
            numberOfCoachingRequestsFromClients: 3,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToReceivedRequests, '
    'user is a coach and does not have own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
      );
      final List<CoachingRequest> requestsReceivedFromCoaches = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: false),
      ];
      final List<CoachingRequest> updatedReqsFromCoaches = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: false),
        createCoachingRequest(id: 'r4', isAccepted: false),
        createCoachingRequest(id: 'r5', isAccepted: false),
      ];
      final List<CoachingRequest> requestsReceivedFromClients = [
        createCoachingRequest(id: 'r11', isAccepted: false),
        createCoachingRequest(id: 'r12', isAccepted: true),
        createCoachingRequest(id: 'r13', isAccepted: true),
      ];
      final List<CoachingRequest> updatedReqsFromClients = [
        createCoachingRequest(id: 'r11', isAccepted: false),
        createCoachingRequest(id: 'r12', isAccepted: true),
        createCoachingRequest(id: 'r13', isAccepted: true),
        createCoachingRequest(id: 'r14', isAccepted: false),
        createCoachingRequest(id: 'r15', isAccepted: false),
      ];
      final StreamController<List<CoachingRequest>>
          requestsReceivedFromCoaches$ = StreamController()
            ..add(requestsReceivedFromCoaches);
      final StreamController<List<CoachingRequest>>
          requestsReceivedFromClients$ = StreamController()
            ..add(requestsReceivedFromClients);

      blocTest(
        'should listen to number of coaching requests received from clients and coaches',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
          when(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).thenAnswer((_) => requestsReceivedFromClients$.stream);
          when(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).thenAnswer((_) => requestsReceivedFromCoaches$.stream);
        },
        act: (cubit) async {
          cubit.listenToReceivedRequests();
          await cubit.stream.first;
          requestsReceivedFromCoaches$.add(updatedReqsFromCoaches);
          await cubit.stream.first;
          requestsReceivedFromClients$.add(updatedReqsFromClients);
        },
        expect: () => [
          const NotificationsState(
            numberOfCoachingRequestsFromCoaches: 2,
            numberOfCoachingRequestsFromClients: 1,
          ),
          const NotificationsState(
            numberOfCoachingRequestsFromCoaches: 4,
            numberOfCoachingRequestsFromClients: 1,
          ),
          const NotificationsState(
            numberOfCoachingRequestsFromCoaches: 4,
            numberOfCoachingRequestsFromClients: 3,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToAwaitingMessages, '
    'logged user is not a coach and does not have own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
      );

      blocTest(
        'should not listen to any awaiting messages',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
        },
        act: (cubit) => cubit.listenToAwaitingMessages(),
        expect: () => [
          const NotificationsState(),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToAwaitingMessages, '
    'logged user is not a coach and has own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        coachId: 'c1',
      );
      final StreamController<bool> doesUserHaveUnreadMsgsFromCoach$ =
          BehaviorSubject.seeded(false);

      blocTest(
        'should only listen to awaiting messages from coach',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'c1',
            ),
          ).thenAnswer((_) => Future.value('chat4'));
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat4',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromCoach$.stream);
        },
        act: (cubit) async {
          cubit.listenToAwaitingMessages();
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromCoach$.add(true);
        },
        expect: () => [
          const NotificationsState(areThereUnreadMessagesFromCoach: false),
          const NotificationsState(areThereUnreadMessagesFromCoach: true),
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
              chatId: 'chat4',
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToAwaitingMessages, '
    'logged user is a coach and does not have own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
      );
      final List<Person> clients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
      ];
      final List<Person> updatedClients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
        createPerson(id: 'p3'),
      ];
      final StreamController<List<Person>> clients$ = StreamController()
        ..add(clients);
      final StreamController<bool> doesUserHaveUnreadMsgsFromClient1$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMsgsFromClient2$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMsgsFromClient3$ =
          BehaviorSubject.seeded(false);

      blocTest(
        'should only listen to awaiting messages from clients',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
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
              user2Id: 'p3',
            ),
          ).thenAnswer((_) => Future.value('chat3'));
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat1',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromClient1$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat2',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromClient2$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat3',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromClient3$.stream);
        },
        act: (cubit) async {
          cubit.listenToAwaitingMessages();
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromClient2$.add(true);
          await cubit.stream.first;
          clients$.add(updatedClients);
          doesUserHaveUnreadMsgsFromClient3$.add(true);
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromClient2$.add(false);
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromClient1$.add(true);
        },
        expect: () => [
          const NotificationsState(idsOfClientsWithAwaitingMessages: []),
          const NotificationsState(idsOfClientsWithAwaitingMessages: ['p2']),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p2', 'p3'],
          ),
          const NotificationsState(idsOfClientsWithAwaitingMessages: ['p3']),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p1', 'p3'],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
          ).called(1);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p1',
            ),
          ).called(2);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p2',
            ),
          ).called(2);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p3',
            ),
          ).called(1);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat1',
              userId: loggedUserId,
            ),
          ).called(2);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat2',
              userId: loggedUserId,
            ),
          ).called(2);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat3',
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'listenToAwaitingMessages, '
    'logged user is a coach and has own coach',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.coach,
        coachId: 'c1',
      );
      final List<Person> clients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
      ];
      final List<Person> updatedClients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
        createPerson(id: 'p3'),
      ];
      final StreamController<List<Person>> clients$ = StreamController()
        ..add(clients);
      final StreamController<bool> doesUserHaveUnreadMsgsFromClient1$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMsgsFromClient2$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMsgsFromClient3$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMsgsFromCoach$ =
          BehaviorSubject.seeded(false);

      blocTest(
        'should listen to awaiting messages from clients and coach',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: loggedUser);
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
              user2Id: 'p3',
            ),
          ).thenAnswer((_) => Future.value('chat3'));
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'c1',
            ),
          ).thenAnswer((_) => Future.value('chat4'));
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat1',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromClient1$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat2',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromClient2$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat3',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromClient3$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat4',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMsgsFromCoach$.stream);
        },
        act: (cubit) async {
          cubit.listenToAwaitingMessages();
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromClient2$.add(true);
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromCoach$.add(true);
          await cubit.stream.first;
          clients$.add(updatedClients);
          doesUserHaveUnreadMsgsFromClient3$.add(true);
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromClient2$.add(false);
          await cubit.stream.first;
          doesUserHaveUnreadMsgsFromClient1$.add(true);
        },
        expect: () => [
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: [],
            areThereUnreadMessagesFromCoach: false,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p2'],
            areThereUnreadMessagesFromCoach: false,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p2'],
            areThereUnreadMessagesFromCoach: true,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p2', 'p3'],
            areThereUnreadMessagesFromCoach: true,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p3'],
            areThereUnreadMessagesFromCoach: true,
          ),
          const NotificationsState(
            idsOfClientsWithAwaitingMessages: ['p1', 'p3'],
            areThereUnreadMessagesFromCoach: true,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
          ).called(1);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p1',
            ),
          ).called(2);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p2',
            ),
          ).called(2);
          verify(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'p3',
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
          ).called(2);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat2',
              userId: loggedUserId,
            ),
          ).called(2);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat3',
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'chat4',
              userId: loggedUserId,
            ),
          ).called(1);
        },
      );
    },
  );
}
