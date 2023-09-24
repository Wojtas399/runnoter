import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/cubit/home/home_cubit.dart';
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
import '../../../creators/settings_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_chat_repository.dart';
import '../../../mock/domain/repository/mock_message_repository.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerSingleton<ChatRepository>(chatRepository);
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(coachingRequestService);
    reset(personRepository);
    reset(chatRepository);
    reset(messageRepository);
  });

  group(
    'initialize',
    () {
      final User loggedUserData = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        name: 'Jack',
        settings: createSettings(
          themeMode: ThemeMode.dark,
          language: Language.polish,
          distanceUnit: DistanceUnit.miles,
          paceUnit: PaceUnit.milesPerHour,
        ),
        coachId: 'coach1',
      );
      final User updatedLoggedUserData = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        name: 'James',
        settings: createSettings(
          themeMode: ThemeMode.light,
          language: Language.english,
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.milesPerHour,
        ),
        coachId: 'coach1',
      );
      final Person client1 = createPerson(id: 'cl1', name: 'first client');
      final Person client2 = createPerson(id: 'cl2', name: 'second client');
      final Person coach = createPerson(id: 'co1', name: 'coach');
      final List<CoachingRequest> requestsSentToClients = [
        createCoachingRequest(
          id: 'r1',
          receiverId: 'cl3',
          isAccepted: false,
        ),
        createCoachingRequest(
          id: 'r2',
          receiverId: client1.id,
          isAccepted: true,
        ),
        createCoachingRequest(
          id: 'r3',
          receiverId: client2.id,
          isAccepted: true,
        ),
      ];
      final List<CoachingRequest> requestsSentToCoaches = [
        createCoachingRequest(
          id: 'r4',
          receiverId: coach.id,
          isAccepted: true,
        ),
        createCoachingRequest(
          id: 'r5',
          receiverId: 'co2',
          isAccepted: false,
        ),
      ];
      final List<Person> clients = [
        createPerson(id: 'u2'),
        createPerson(id: 'u3'),
      ];
      final List<Person> updatedClients = [
        createPerson(id: 'u2'),
        createPerson(id: 'u3'),
        createPerson(id: 'u4'),
      ];
      final StreamController<User?> loggedUserData$ =
          BehaviorSubject.seeded(loggedUserData);
      final StreamController<List<CoachingRequest>> clientsRequests$ =
          StreamController()..add(requestsSentToClients);
      final StreamController<List<CoachingRequest>> coachesRequests$ =
          StreamController()..add(requestsSentToCoaches);
      final StreamController<List<Person>> clients$ = StreamController()
        ..add(clients);
      final StreamController<bool> doesUserHaveUnreadMessagesInChat1$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMessagesInChat2$ =
          BehaviorSubject.seeded(true);
      final StreamController<bool> doesUserHaveUnreadMessagesInChat3$ =
          BehaviorSubject.seeded(false);
      final StreamController<bool> doesUserHaveUnreadMessagesInCoachChat$ =
          BehaviorSubject.seeded(false);
      final List<CoachingRequestShort> acceptedClientRequests = [
        CoachingRequestShort(id: 'r2', personToDisplay: client1),
        CoachingRequestShort(id: 'r3', personToDisplay: client2),
      ];

      blocTest(
        'should listen to logged user data, accepted client requests and '
        'accepted coach request and should listen to number of chats with '
        'unread received messages',
        build: () => HomeCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(userStream: loggedUserData$.stream);
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
          personRepository.mockGetPersonsByCoachId(
            personsStream: clients$.stream,
          );
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'u2',
            ),
          ).thenAnswer((_) => Future.value('c1'));
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'u3',
            ),
          ).thenAnswer((_) => Future.value('c2'));
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'u4',
            ),
          ).thenAnswer((_) => Future.value('c3'));
          when(
            () => chatRepository.findChatIdByUsers(
              user1Id: loggedUserId,
              user2Id: 'coach1',
            ),
          ).thenAnswer((_) => Future.value('c4'));
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c1',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMessagesInChat1$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c2',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMessagesInChat2$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c3',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMessagesInChat3$.stream);
          when(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c4',
              userId: loggedUserId,
            ),
          ).thenAnswer((_) => doesUserHaveUnreadMessagesInCoachChat$.stream);
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          coachesRequests$.add([]);
          await cubit.stream.first;
          clientsRequests$.add([]);
          await cubit.stream.first;
          loggedUserData$.add(updatedLoggedUserData);
          await cubit.stream.first;
          doesUserHaveUnreadMessagesInChat1$.add(true);
          await cubit.stream.first;
          clients$.add(updatedClients);
          doesUserHaveUnreadMessagesInChat3$.add(true);
          await cubit.stream.first;
          doesUserHaveUnreadMessagesInCoachChat$.add(true);
        },
        expect: () => [
          const HomeState(status: CubitStatusLoading()),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: loggedUserData.accountType,
            loggedUserName: loggedUserData.name,
            appSettings: loggedUserData.settings,
            acceptedClientRequests: acceptedClientRequests,
            acceptedCoachRequest: CoachingRequestShort(
              id: 'r4',
              personToDisplay: coach,
            ),
            idsOfClientsWithAwaitingMessages: const ['u3'],
            areThereUnreadMessagesFromCoach: false,
          ),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: loggedUserData.accountType,
            loggedUserName: loggedUserData.name,
            appSettings: loggedUserData.settings,
            acceptedClientRequests: acceptedClientRequests,
            idsOfClientsWithAwaitingMessages: const ['u3'],
            areThereUnreadMessagesFromCoach: false,
          ),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: loggedUserData.accountType,
            loggedUserName: loggedUserData.name,
            appSettings: loggedUserData.settings,
            acceptedClientRequests: const [],
            idsOfClientsWithAwaitingMessages: const ['u3'],
            areThereUnreadMessagesFromCoach: false,
          ),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: updatedLoggedUserData.accountType,
            loggedUserName: updatedLoggedUserData.name,
            appSettings: updatedLoggedUserData.settings,
            acceptedClientRequests: const [],
            idsOfClientsWithAwaitingMessages: const ['u3'],
            areThereUnreadMessagesFromCoach: false,
          ),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: updatedLoggedUserData.accountType,
            loggedUserName: updatedLoggedUserData.name,
            appSettings: updatedLoggedUserData.settings,
            acceptedClientRequests: const [],
            idsOfClientsWithAwaitingMessages: const ['u2', 'u3'],
            areThereUnreadMessagesFromCoach: false,
          ),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: updatedLoggedUserData.accountType,
            loggedUserName: updatedLoggedUserData.name,
            appSettings: updatedLoggedUserData.settings,
            acceptedClientRequests: const [],
            idsOfClientsWithAwaitingMessages: const ['u2', 'u3', 'u4'],
            areThereUnreadMessagesFromCoach: false,
          ),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: updatedLoggedUserData.accountType,
            loggedUserName: updatedLoggedUserData.name,
            appSettings: updatedLoggedUserData.settings,
            acceptedClientRequests: const [],
            idsOfClientsWithAwaitingMessages: const ['u2', 'u3', 'u4'],
            areThereUnreadMessagesFromCoach: true,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(2);
          verify(
            () => personRepository.refreshPersonsByCoachId(
              coachId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => userRepository.refreshUserById(userId: loggedUserId),
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
            () => personRepository.getPersonById(personId: client1.id),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: client2.id),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: coach.id),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
          ).called(1);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c1',
              userId: loggedUserId,
            ),
          ).called(2);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c2',
              userId: loggedUserId,
            ),
          ).called(2);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c3',
              userId: loggedUserId,
            ),
          ).called(1);
          verify(
            () => messageRepository.doesUserHaveUnreadMessagesInChat(
              chatId: 'c4',
              userId: loggedUserId,
            ),
          ).called(2);
        },
      );

      blocTest(
        'logged user does not exist, '
        'should emit no logged user status',
        build: () => HomeCubit(),
        setUp: () => authService.mockGetLoggedUserId(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(status: CubitStatusLoading()),
          const HomeState(status: CubitStatusNoLoggedUser()),
        ],
        verify: (_) => verify(() => authService.loggedUserId$).called(1),
      );
    },
  );

  blocTest(
    'delete coaching request, '
    "should call coaching request service's method to delete request",
    build: () => HomeCubit(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (cubit) => cubit.deleteCoachingRequest('r1'),
    expect: () => [],
    verify: (_) => verify(
      () => coachingRequestService.deleteCoachingRequest(requestId: 'r1'),
    ).called(1),
  );

  blocTest(
    'sign out, '
    'should call auth service method to sign out and should emit signed out info',
    build: () => HomeCubit(),
    setUp: () => authService.mockSignOut(),
    act: (cubit) => cubit.signOut(),
    expect: () => [
      const HomeState(status: CubitStatusLoading()),
      const HomeState(
        status: CubitStatusComplete(info: HomeCubitInfo.userSignedOut),
      ),
    ],
    verify: (_) => verify(authService.signOut).called(1),
  );
}
