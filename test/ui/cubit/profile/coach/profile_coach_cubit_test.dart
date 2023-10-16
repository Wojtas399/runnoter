import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/additional_model/coaching_request.dart';
import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/interface/repository/person_repository.dart';
import 'package:runnoter/data/interface/repository/user_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/interface/service/coaching_request_service.dart';
import 'package:runnoter/domain/additional_model/coaching_request_with_person.dart';
import 'package:runnoter/domain/use_case/delete_chat_use_case.dart';
import 'package:runnoter/domain/use_case/get_received_coaching_requests_with_sender_info_use_case.dart';
import 'package:runnoter/domain/use_case/get_sent_coaching_requests_with_receiver_info_use_case.dart';
import 'package:runnoter/domain/use_case/load_chat_id_use_case.dart';
import 'package:runnoter/ui/cubit/profile/coach/profile_coach_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../creators/person_creator.dart';
import '../../../../creators/user_creator.dart';
import '../../../../mock/domain/repository/mock_person_repository.dart';
import '../../../../mock/domain/repository/mock_user_repository.dart';
import '../../../../mock/domain/service/mock_auth_service.dart';
import '../../../../mock/domain/service/mock_coaching_request_service.dart';
import '../../../../mock/domain/use_case/mock_delete_chat_use_case.dart';
import '../../../../mock/domain/use_case/mock_get_received_coaching_requests_with_sender_info_use_case.dart';
import '../../../../mock/domain/use_case/mock_get_sent_coaching_requests_with_receiver_info_use_case.dart';
import '../../../../mock/domain/use_case/mock_load_chat_id_use_case.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final personRepository = MockPersonRepository();
  final coachingRequestService = MockCoachingRequestService();
  final loadChatIdUseCase = MockLoadChatIdUseCase();
  final getSentCoachingRequestsWithReceiverInfoUseCase =
      MockGetSentCoachingRequestsWithReceiverInfoUseCase();
  final getReceivedCoachingRequestsWithSenderInfoUseCase =
      MockGetReceivedCoachingRequestsWithSenderInfoUseCase();
  final deleteChatUseCase = MockDeleteChatUseCase();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerFactory<PersonRepository>(() => personRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerFactory<LoadChatIdUseCase>(() => loadChatIdUseCase);
    GetIt.I.registerFactory<GetSentCoachingRequestsWithReceiverInfoUseCase>(
      () => getSentCoachingRequestsWithReceiverInfoUseCase,
    );
    GetIt.I.registerFactory<GetReceivedCoachingRequestsWithSenderInfoUseCase>(
      () => getReceivedCoachingRequestsWithSenderInfoUseCase,
    );
    GetIt.I.registerFactory<DeleteChatUseCase>(() => deleteChatUseCase);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(personRepository);
    reset(coachingRequestService);
    reset(loadChatIdUseCase);
    reset(getSentCoachingRequestsWithReceiverInfoUseCase);
    reset(getReceivedCoachingRequestsWithSenderInfoUseCase);
    reset(deleteChatUseCase);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileCoachCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  group(
    'initialize, ',
    () {
      final User loggedUser = createUser(id: loggedUserId);
      final User updatedLoggedUser = createUser(
        id: loggedUserId,
        coachId: 'c1',
      );
      final Person coach = createPerson(
        id: 'c1',
        name: 'name',
        surname: 'surname',
        email: 'email',
      );
      final Person updatedCoach = createPerson(
        id: 'c1',
        name: 'na',
        surname: 'su',
        email: 'em',
      );
      final sentRequests = [
        CoachingRequestWithPerson(id: 'r1', person: createPerson(id: 'p1')),
      ];
      final updatedSentRequests = [
        ...sentRequests,
        CoachingRequestWithPerson(id: 'r2', person: createPerson(id: 'p2')),
      ];
      final receivedRequests = [
        CoachingRequestWithPerson(id: 'r3', person: createPerson(id: 'p3')),
      ];
      final updatedReceivedRequests = [
        ...receivedRequests,
        CoachingRequestWithPerson(id: 'r4', person: createPerson(id: 'p4')),
      ];
      final StreamController<User> loggedUser$ = StreamController()
        ..add(loggedUser);
      final StreamController<Person?> coach$ = StreamController()..add(coach);
      final StreamController<List<CoachingRequestWithPerson>> sentRequests$ =
          BehaviorSubject.seeded(sentRequests);
      final StreamController<List<CoachingRequestWithPerson>>
          receivedRequests$ = BehaviorSubject.seeded(receivedRequests);

      blocTest(
        'should listen to logged user data, '
        'if logged user has a coach should only listen to coach data '
        'else should only listen to sent and received coaching requests',
        build: () => ProfileCoachCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(userStream: loggedUser$.stream);
          personRepository.mockGetPersonById(personStream: coach$.stream);
          getSentCoachingRequestsWithReceiverInfoUseCase.mock(
            requests$: sentRequests$.stream,
          );
          getReceivedCoachingRequestsWithSenderInfoUseCase.mock(
            requests$: receivedRequests$.stream,
          );
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          sentRequests$.add(updatedSentRequests);
          await cubit.stream.first;
          receivedRequests$.add(updatedReceivedRequests);
          await cubit.stream.first;
          loggedUser$.add(updatedLoggedUser);
          await cubit.stream.first;
          coach$.add(updatedCoach);
          await cubit.stream.first;
          loggedUser$.add(loggedUser);
        },
        expect: () => [
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: sentRequests,
            receivedRequests: receivedRequests,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: updatedSentRequests,
            receivedRequests: receivedRequests,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: updatedSentRequests,
            receivedRequests: updatedReceivedRequests,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            coachId: coach.id,
            coachFullName: '${coach.name} ${coach.surname}',
            coachEmail: coach.email,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            coachId: updatedCoach.id,
            coachFullName: '${updatedCoach.name} ${updatedCoach.surname}',
            coachEmail: updatedCoach.email,
          ),
          ProfileCoachState(
            status: const CubitStatusComplete(),
            sentRequests: updatedSentRequests,
            receivedRequests: updatedReceivedRequests,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: 'c1'),
          ).called(1);
          verify(
            () => getSentCoachingRequestsWithReceiverInfoUseCase.execute(
              senderId: loggedUserId,
              requestDirection: CoachingRequestDirection.clientToCoach,
              requestStatuses: SentCoachingRequestStatuses.onlyUnaccepted,
            ),
          ).called(2);
          verify(
            () => getReceivedCoachingRequestsWithSenderInfoUseCase.execute(
              receiverId: loggedUserId,
              requestDirection: CoachingRequestDirection.coachToClient,
              requestStatuses: ReceivedCoachingRequestStatuses.onlyUnaccepted,
            ),
          ).called(2);
        },
      );
    },
  );

  blocTest(
    'acceptRequest, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => ProfileCoachCubit(
      initialState: ProfileCoachState(
        status: const CubitStatusComplete(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'u2'),
          ),
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'u3'),
          ),
        ],
      ),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.acceptRequest('r1'),
    expect: () => [
      ProfileCoachState(
        status: const CubitStatusNoLoggedUser(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'u2'),
          ),
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'u3'),
          ),
        ],
      ),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'acceptRequest, '
    "should call coaching request service's method to update request with isAccepted param set as true, "
    "should call user repository's method to update logged user with new coach id",
    build: () => ProfileCoachCubit(
      initialState: ProfileCoachState(
        status: const CubitStatusComplete(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'u2'),
          ),
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'u3'),
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      coachingRequestService.mockUpdateCoachingRequest();
      userRepository.mockUpdateUser();
    },
    act: (cubit) => cubit.acceptRequest('r1'),
    expect: () => [
      ProfileCoachState(
        status: const CubitStatusLoading(),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'u2'),
          ),
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'u3'),
          ),
        ],
      ),
      ProfileCoachState(
        status: const CubitStatusComplete<ProfileCoachCubitInfo>(
          info: ProfileCoachCubitInfo.requestAccepted,
        ),
        receivedRequests: [
          CoachingRequestWithPerson(
            id: 'r2',
            person: createPerson(id: 'u2'),
          ),
          CoachingRequestWithPerson(
            id: 'r1',
            person: createPerson(id: 'u3'),
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
    'deleteRequest, '
    'coach to client'
    "should call coaching request service's method to delete request, "
    'should emit requestDeleted info',
    build: () => ProfileCoachCubit(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (cubit) => cubit.deleteRequest(
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
    'deleteRequest, '
    'client to coach'
    "should call coaching request service's method to delete request, "
    'should emit requestUndid info',
    build: () => ProfileCoachCubit(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (cubit) => cubit.deleteRequest(
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

  group(
    'loadChatId, '
    'coach id does not exist, ',
    () {
      String? chatId;

      blocTest(
        'should return null',
        build: () => ProfileCoachCubit(),
        act: (cubit) async {
          chatId = await cubit.loadChatId();
        },
        expect: () => [],
        verify: (_) => expect(chatId, null),
      );
    },
  );

  group(
    'loadChatId, '
    'logged user does not exist, ',
    () {
      String? chatId;

      blocTest(
        'should return null',
        build: () => ProfileCoachCubit(
          initialState: const ProfileCoachState(
            status: CubitStatusComplete(),
            coachId: 'c1',
          ),
        ),
        setUp: () => authService.mockGetLoggedUserId(),
        act: (cubit) async {
          chatId = await cubit.loadChatId();
        },
        verify: (_) {
          expect(chatId, null);
          verify(() => authService.loggedUserId$).called(1);
        },
      );
    },
  );

  group(
    'loadChatId, ',
    () {
      String? chatId;

      blocTest(
        'should call use case to load chat id and should return loaded chat id',
        build: () => ProfileCoachCubit(
          initialState: const ProfileCoachState(
            status: CubitStatusComplete(),
            coachId: 'c1',
          ),
        ),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          loadChatIdUseCase.mock(chatId: 'chat1');
        },
        act: (cubit) async {
          chatId = await cubit.loadChatId();
        },
        expect: () => [
          const ProfileCoachState(status: CubitStatusLoading(), coachId: 'c1'),
          const ProfileCoachState(status: CubitStatusComplete(), coachId: 'c1'),
        ],
        verify: (_) {
          expect(chatId, 'chat1');
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => loadChatIdUseCase.execute(
              user1Id: loggedUserId,
              user2Id: 'c1',
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'deleteCoach, '
    'coachId is null, '
    'should do nothing',
    build: () => ProfileCoachCubit(),
    act: (cubit) => cubit.deleteCoach(),
    expect: () => [],
  );

  blocTest(
    'deleteCoach, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileCoachCubit(
      initialState: const ProfileCoachState(
        status: CubitStatusComplete(),
        coachId: 'c1',
      ),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.deleteCoach(),
    expect: () => [
      const ProfileCoachState(
        status: CubitStatusNoLoggedUser(),
        coachId: 'c1',
      ),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'deleteCoach, '
    'should call user repository method to update user with coach id set as null, '
    'should call coaching request service method to delete request between logged user and coach, '
    'if chat exists should call use case to delete chat, '
    'should emit coachDeleted info',
    build: () => ProfileCoachCubit(
      initialState: const ProfileCoachState(
        status: CubitStatusComplete(),
        coachId: 'c1',
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
      coachingRequestService.mockDeleteCoachingRequestBetweenUsers();
      loadChatIdUseCase.mock(chatId: 'chat1');
      deleteChatUseCase.mock();
    },
    act: (cubit) => cubit.deleteCoach(),
    expect: () => [
      const ProfileCoachState(status: CubitStatusLoading(), coachId: 'c1'),
      const ProfileCoachState(
        status: CubitStatusComplete<ProfileCoachCubitInfo>(
          info: ProfileCoachCubitInfo.coachDeleted,
        ),
        coachId: 'c1',
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
      verify(
        () => coachingRequestService.deleteCoachingRequestBetweenUsers(
          user1Id: loggedUserId,
          user2Id: 'c1',
        ),
      ).called(1);
      verify(() => deleteChatUseCase.execute(chatId: 'chat1')).called(1);
    },
  );

  blocTest(
    'deleteCoach, '
    'should call user repository method to update user with coach id set as null, '
    'should call coaching request service method to delete request between logged user and coach, '
    'if chat does not exist should not call use case to delete chat, '
    'should emit coachDeleted info',
    build: () => ProfileCoachCubit(
      initialState: const ProfileCoachState(
        status: CubitStatusComplete(),
        coachId: 'c1',
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
      coachingRequestService.mockDeleteCoachingRequestBetweenUsers();
      loadChatIdUseCase.mock();
    },
    act: (cubit) => cubit.deleteCoach(),
    expect: () => [
      const ProfileCoachState(status: CubitStatusLoading(), coachId: 'c1'),
      const ProfileCoachState(
        status: CubitStatusComplete<ProfileCoachCubitInfo>(
          info: ProfileCoachCubitInfo.coachDeleted,
        ),
        coachId: 'c1',
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
      verify(
        () => coachingRequestService.deleteCoachingRequestBetweenUsers(
          user1Id: loggedUserId,
          user2Id: 'c1',
        ),
      ).called(1);
    },
  );

  group(
    'checkIfStillHasCoach, '
    'logged user does not exist',
    () {
      bool? result;

      blocTest(
        'should emit no logged user status and should return false',
        build: () => ProfileCoachCubit(),
        setUp: () => authService.mockGetLoggedUserId(),
        act: (cubit) async {
          result = await cubit.checkIfStillHasCoach();
        },
        expect: () => [
          const ProfileCoachState(status: CubitStatusNoLoggedUser()),
        ],
        verify: (_) {
          expect(result, false);
          verify(() => authService.loggedUserId$).called(1);
        },
      );
    },
  );

  group(
    'checkIfStillHasCoach',
    () {
      bool? result;

      blocTest(
        'should call user repository method to refresh logged user, '
        'should load logged user from repo, '
        'if logged user does not have a coach should emit error status with '
        'userNoLongerHasCoach error and should return false',
        build: () => ProfileCoachCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockRefreshUserById();
          userRepository.mockGetUserById(user: createUser(coachId: null));
        },
        act: (cubit) async {
          result = await cubit.checkIfStillHasCoach();
        },
        expect: () => [
          const ProfileCoachState(
            status: CubitStatusError<ProfileCoachCubitError>(
              error: ProfileCoachCubitError.userNoLongerHasCoach,
            ),
          ),
        ],
        verify: (_) {
          expect(result, false);
          verify(() => authService.loggedUserId$).called(1);
        },
      );
    },
  );

  group(
    'checkIfStillHasCoach',
    () {
      bool? result;

      blocTest(
        'should call user repository method to refresh logged user, '
        'should load logged user from repo, '
        'if logged user has a coach should return true',
        build: () => ProfileCoachCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockRefreshUserById();
          userRepository.mockGetUserById(user: createUser(coachId: 'c1'));
        },
        act: (cubit) async {
          result = await cubit.checkIfStillHasCoach();
        },
        expect: () => [],
        verify: (_) {
          expect(result, true);
          verify(() => authService.loggedUserId$).called(1);
        },
      );
    },
  );
}
