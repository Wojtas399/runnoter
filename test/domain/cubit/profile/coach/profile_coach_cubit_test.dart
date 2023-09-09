import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/cubit/profile/coach/profile_coach_cubit.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';
import 'package:runnoter/domain/use_case/load_chat_id_use_case.dart';

import '../../../../creators/coaching_request_creator.dart';
import '../../../../creators/person_creator.dart';
import '../../../../creators/user_creator.dart';
import '../../../../mock/domain/repository/mock_person_repository.dart';
import '../../../../mock/domain/repository/mock_user_repository.dart';
import '../../../../mock/domain/service/mock_auth_service.dart';
import '../../../../mock/domain/service/mock_coaching_request_service.dart';
import '../../../../mock/domain/use_case/mock_load_chat_id_use_case.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final personRepository = MockPersonRepository();
  final coachingRequestService = MockCoachingRequestService();
  final loadChatIdUseCase = MockLoadChatIdUseCase();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerFactory<PersonRepository>(() => personRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerFactory<LoadChatIdUseCase>(() => loadChatIdUseCase);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(personRepository);
    reset(coachingRequestService);
    reset(loadChatIdUseCase);
  });

  blocTest(
    'initialize coach listener, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileCoachCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.initializeCoachListener(),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  group(
    'initialize coach listener, '
    'coach is not null',
    () {
      final Person expectedCoach = createPerson(
        id: 'c1',
        name: 'name',
        surname: 'surname',
        email: 'email',
      );
      final Person expectedUpdatedCoach = createPerson(
        id: 'c1',
        name: 'na',
        surname: 'su',
        email: 'em',
      );
      final StreamController<Person?> coach$ = StreamController()
        ..add(expectedCoach);

      blocTest(
        'should set listener of coach',
        build: () => ProfileCoachCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(
            user: createUser(coachId: expectedCoach.id),
          );
          personRepository.mockGetPersonById(personStream: coach$.stream);
        },
        act: (bloc) {
          bloc.initializeCoachListener();
          coach$.add(expectedUpdatedCoach);
        },
        expect: () => [
          ProfileCoachState(
            status: const CubitStatusComplete(),
            coachId: expectedCoach.id,
            coachFullName: '${expectedCoach.name} ${expectedCoach.surname}',
            coachEmail: expectedCoach.email,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            coachId: expectedUpdatedCoach.id,
            coachFullName:
                '${expectedUpdatedCoach.name} ${expectedUpdatedCoach.surname}',
            coachEmail: expectedUpdatedCoach.email,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: expectedCoach.id),
          ).called(1);
        },
      );
    },
  );

  group(
    'initialize coach listener, '
    'coach is null',
    () {
      final Person person1 = createPerson(id: 'p1');
      final Person person2 = createPerson(id: 'p2');
      final sentRequests = [
        createCoachingRequest(id: 'r1', receiverId: person1.id),
      ];
      final receivedRequests = [
        createCoachingRequest(id: 'r2', senderId: person2.id),
      ];
      final sentRequestDetails = [
        CoachingRequestShort(id: 'r1', personToDisplay: person1),
      ];
      final receivedRequestDetails = [
        CoachingRequestShort(id: 'r2', personToDisplay: person2),
      ];
      final StreamController<List<CoachingRequest>> sentRequests$ =
          StreamController()..add(sentRequests);
      final StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()..add(receivedRequests);

      blocTest(
        'should set listener of sent and received requests',
        build: () => ProfileCoachCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(user: createUser(coachId: null));
          coachingRequestService.mockGetCoachingRequestsBySenderId(
            requestsStream: sentRequests$.stream,
          );
          coachingRequestService.mockGetCoachingRequestsByReceiverId(
            requestsStream: receivedRequests$.stream,
          );
          when(
            () => personRepository.getPersonById(personId: person1.id),
          ).thenAnswer((_) => Stream.value(person1));
          when(
            () => personRepository.getPersonById(personId: person2.id),
          ).thenAnswer((_) => Stream.value(person2));
        },
        act: (bloc) async {
          bloc.initializeCoachListener();
          sentRequests$.add([]);
          receivedRequests$.add([]);
        },
        expect: () => [
          const ProfileCoachState(status: CubitStatusComplete()),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: sentRequestDetails,
            receivedRequests: receivedRequestDetails,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: const [],
            receivedRequests: receivedRequestDetails,
          ),
          const ProfileCoachState(
            status: CubitStatusComplete(),
            sentRequests: [],
            receivedRequests: [],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(2);
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
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person1.id),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person2.id),
          ).called(1);
        },
      );
    },
  );

  group(
    'initialize requests listener, ',
    () {
      final Person person1 = createPerson(id: 'u2');
      final Person person2 = createPerson(id: 'u3');
      final sentRequests = [
        createCoachingRequest(id: 'r1', receiverId: person1.id),
      ];
      final receivedRequests = [
        createCoachingRequest(id: 'r2', senderId: person2.id),
      ];
      final sentRequestDetails = [
        CoachingRequestShort(id: 'r1', personToDisplay: person1),
      ];
      final receivedRequestDetails = [
        CoachingRequestShort(id: 'r2', personToDisplay: person2),
      ];
      final StreamController<List<CoachingRequest>> sentRequests$ =
          StreamController()..add(sentRequests);
      final StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()..add(receivedRequests);

      blocTest(
        'should set listener of sent and received coaching requests',
        build: () => ProfileCoachCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          when(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).thenAnswer((_) => sentRequests$.stream);
          when(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).thenAnswer((_) => receivedRequests$.stream);
          when(
            () => personRepository.getPersonById(personId: person1.id),
          ).thenAnswer((_) => Stream.value(person1));
          when(
            () => personRepository.getPersonById(personId: person2.id),
          ).thenAnswer((_) => Stream.value(person2));
        },
        act: (bloc) async {
          bloc.initializeRequestsListener();
          sentRequests$.add([]);
          receivedRequests$.add([]);
        },
        expect: () => [
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: sentRequestDetails,
            receivedRequests: receivedRequestDetails,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: const [],
            receivedRequests: receivedRequestDetails,
          ),
          const ProfileCoachState(
            status: CubitStatusComplete(),
            sentRequests: [],
            receivedRequests: [],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person1.id),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person2.id),
          ).called(1);
        },
      );
    },
  );

  group(
    'remove requests listener, ',
    () {
      final Person person1 = createPerson(id: 'p1');
      final Person person2 = createPerson(id: 'p2');
      final sentRequests = [
        createCoachingRequest(id: 'r1', receiverId: person1.id),
      ];
      final receivedRequests = [
        createCoachingRequest(id: 'r2', senderId: person2.id),
      ];
      final StreamController<List<CoachingRequest>> sentRequests$ =
          StreamController()..add(sentRequests);
      final StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()..add(receivedRequests);

      blocTest(
        'should remove listener of sent and received coaching requests',
        build: () => ProfileCoachCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          when(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).thenAnswer((_) => sentRequests$.stream);
          when(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).thenAnswer((_) => receivedRequests$.stream);
          when(
            () => personRepository.getPersonById(personId: person1.id),
          ).thenAnswer((_) => Stream.value(person1));
          when(
            () => personRepository.getPersonById(personId: person2.id),
          ).thenAnswer((_) => Stream.value(person2));
        },
        act: (bloc) async {
          bloc.initializeRequestsListener();
          await bloc.stream.first;
          bloc.removeRequestsListener();
          sentRequests$.add([]);
          receivedRequests$.add([]);
        },
        expect: () => [
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: [
              CoachingRequestShort(id: 'r1', personToDisplay: person1),
            ],
            receivedRequests: [
              CoachingRequestShort(id: 'r2', personToDisplay: person2),
            ],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person1.id),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: person2.id),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'accept request, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => ProfileCoachCubit(
      initialState: ProfileCoachState(
        status: const CubitStatusComplete(),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.acceptRequest('r1'),
    expect: () => [
      ProfileCoachState(
        status: const CubitStatusNoLoggedUser(),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'accept request, '
    "should call coaching request service's method to update request with isAccepted param set as true, "
    "should call user repository's method to update logged user with new coach id",
    build: () => ProfileCoachCubit(
      initialState: ProfileCoachState(
        status: const CubitStatusComplete(),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      coachingRequestService.mockUpdateCoachingRequest();
      userRepository.mockUpdateUser();
    },
    act: (bloc) => bloc.acceptRequest('r1'),
    expect: () => [
      ProfileCoachState(
        status: const CubitStatusLoading(),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
      ProfileCoachState(
        status: const CubitStatusComplete<ProfileCoachCubitInfo>(
          info: ProfileCoachCubitInfo.requestAccepted,
        ),
        receivedRequests: [
          CoachingRequestShort(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestShort(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => coachingRequestService.updateCoachingRequest(
          requestId: 'r1',
          isAccepted: true,
        ),
      ).called(1);
      verify(
        () => userRepository.updateUser(userId: loggedUserId, coachId: 'u3'),
      ).called(1);
    },
  );

  blocTest(
    'delete request, '
    'coach to client'
    "should call coaching request service's method to delete request, "
    'should emit requestDeleted info',
    build: () => ProfileCoachCubit(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (bloc) => bloc.deleteRequest(
      requestId: 'r1',
      requestDirection: CoachingRequestDirection.coachToClient,
    ),
    expect: () => [
      const ProfileCoachState(status: CubitStatusLoading()),
      const ProfileCoachState(
        status: CubitStatusComplete<ProfileCoachCubitInfo>(
          info: ProfileCoachCubitInfo.requestDeleted,
        ),
      ),
    ],
    verify: (_) => verify(
      () => coachingRequestService.deleteCoachingRequest(requestId: 'r1'),
    ).called(1),
  );

  blocTest(
    'delete request, '
    'client to coach'
    "should call coaching request service's method to delete request, "
    'should emit requestUndid info',
    build: () => ProfileCoachCubit(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (bloc) => bloc.deleteRequest(
      requestId: 'r1',
      requestDirection: CoachingRequestDirection.clientToCoach,
    ),
    expect: () => [
      const ProfileCoachState(status: CubitStatusLoading()),
      const ProfileCoachState(
        status: CubitStatusComplete<ProfileCoachCubitInfo>(
          info: ProfileCoachCubitInfo.requestUndid,
        ),
      ),
    ],
    verify: (_) => verify(
      () => coachingRequestService.deleteCoachingRequest(requestId: 'r1'),
    ).called(1),
  );

  blocTest(
    'delete coach, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileCoachCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.deleteCoach(),
    expect: () => [
      const ProfileCoachState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'delete coach, '
    "should call user repository's method to update user with coach id set as null and should emit coachDeleted info",
    build: () => ProfileCoachCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
    },
    act: (bloc) => bloc.deleteCoach(),
    expect: () => [
      const ProfileCoachState(status: CubitStatusLoading()),
      const ProfileCoachState(
        status: CubitStatusComplete<ProfileCoachCubitInfo>(
          info: ProfileCoachCubitInfo.coachDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUser(
          userId: loggedUserId,
          coachIdAsNull: true,
        ),
      ).called(1);
    },
  );

  test(
    'load chat id, '
    'coach id does not exist, '
    'should return null',
    () async {
      authService.mockGetLoggedUserId();
      final cubit = ProfileCoachCubit();

      final String? chatId = await cubit.loadChatId();

      expect(chatId, null);
    },
  );

  test(
    'load chat id, '
    'logged user does not exist, '
    'should return null',
    () async {
      authService.mockGetLoggedUserId();
      final cubit = ProfileCoachCubit(
        initialState: const ProfileCoachState(
          status: CubitStatusInitial(),
          coachId: 'c1',
        ),
      );

      final String? chatId = await cubit.loadChatId();

      expect(chatId, null);
    },
  );

  test(
    'load chat id, '
    'should call use case to load chat id and return loaded chat id',
    () async {
      const String expectedChatId = 'c1';
      authService.mockGetLoggedUserId(userId: loggedUserId);
      loadChatIdUseCase.mock(chatId: expectedChatId);
      final cubit = ProfileCoachCubit(
        initialState: const ProfileCoachState(
          status: CubitStatusInitial(),
          coachId: 'c1',
        ),
      );

      final String? chatId = await cubit.loadChatId();

      expect(chatId, expectedChatId);
    },
  );
}
