import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/bloc/profile/coach/profile_coach_bloc.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../../creators/coaching_request_creator.dart';
import '../../../../creators/person_creator.dart';
import '../../../../creators/user_creator.dart';
import '../../../../mock/domain/repository/mock_person_repository.dart';
import '../../../../mock/domain/repository/mock_user_repository.dart';
import '../../../../mock/domain/service/mock_auth_service.dart';
import '../../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final personRepository = MockPersonRepository();
  final coachingRequestService = MockCoachingRequestService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerFactory<PersonRepository>(() => personRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(personRepository);
    reset(coachingRequestService);
  });

  blocTest(
    'initialize coach listener, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileCoachBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileCoachEventInitializeCoachListener()),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  group(
    'initialize coach listener, '
    'coach is not null',
    () {
      final Person expectedCoach = createPerson(id: 'c1', name: 'name');
      final Person expectedUpdatedCoach = createPerson(id: 'c1', name: 'na');
      final StreamController<Person?> coach$ = StreamController()
        ..add(expectedCoach);

      blocTest(
        'coach is not null, '
        'should set listener of coach',
        build: () => ProfileCoachBloc(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(
            user: createUser(coachId: expectedCoach.id),
          );
          personRepository.mockGetPersonById(personStream: coach$.stream);
        },
        act: (bloc) {
          bloc.add(const ProfileCoachEventInitializeCoachListener());
          coach$.add(expectedUpdatedCoach);
        },
        expect: () => [
          ProfileCoachState(
            status: const BlocStatusComplete(),
            coach: expectedCoach,
          ),
          ProfileCoachState(
            status: const BlocStatusComplete(),
            coach: expectedUpdatedCoach,
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
        CoachingRequestDetails(id: 'r1', personToDisplay: person1),
      ];
      final receivedRequestDetails = [
        CoachingRequestDetails(id: 'r2', personToDisplay: person2),
      ];
      final StreamController<List<CoachingRequest>> sentRequests$ =
          StreamController()..add(sentRequests);
      final StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()..add(receivedRequests);

      blocTest(
        'should set listener of sent and received coaching requests',
        build: () => ProfileCoachBloc(),
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
          bloc.add(const ProfileCoachEventInitializeCoachListener());
          sentRequests$.add([]);
          receivedRequests$.add([]);
        },
        expect: () => [
          const ProfileCoachState(status: BlocStatusComplete()),
          ProfileCoachState(
            status: const BlocStatusComplete(),
            sentCoachingRequests: sentRequestDetails,
            receivedCoachingRequests: receivedRequestDetails,
          ),
          ProfileCoachState(
            status: const BlocStatusComplete(),
            sentCoachingRequests: const [],
            receivedCoachingRequests: receivedRequestDetails,
          ),
          const ProfileCoachState(
            status: BlocStatusComplete(),
            sentCoachingRequests: [],
            receivedCoachingRequests: [],
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
        CoachingRequestDetails(id: 'r1', personToDisplay: person1),
      ];
      final receivedRequestDetails = [
        CoachingRequestDetails(id: 'r2', personToDisplay: person2),
      ];
      final StreamController<List<CoachingRequest>> sentRequests$ =
          StreamController()..add(sentRequests);
      final StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()..add(receivedRequests);

      blocTest(
        'should set listener of sent and received coaching requests',
        build: () => ProfileCoachBloc(),
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
          bloc.add(const ProfileCoachEventInitializeRequestsListener());
          sentRequests$.add([]);
          receivedRequests$.add([]);
        },
        expect: () => [
          ProfileCoachState(
            status: const BlocStatusComplete(),
            sentCoachingRequests: sentRequestDetails,
            receivedCoachingRequests: receivedRequestDetails,
          ),
          ProfileCoachState(
            status: const BlocStatusComplete(),
            sentCoachingRequests: const [],
            receivedCoachingRequests: receivedRequestDetails,
          ),
          const ProfileCoachState(
            status: BlocStatusComplete(),
            sentCoachingRequests: [],
            receivedCoachingRequests: [],
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
        build: () => ProfileCoachBloc(),
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
          bloc.add(const ProfileCoachEventInitializeRequestsListener());
          await bloc.stream.first;
          bloc.add(const ProfileCoachEventRemoveRequestsListener());
          sentRequests$.add([]);
          receivedRequests$.add([]);
        },
        expect: () => [
          ProfileCoachState(
            status: const BlocStatusComplete(),
            sentCoachingRequests: [
              CoachingRequestDetails(id: 'r1', personToDisplay: person1),
            ],
            receivedCoachingRequests: [
              CoachingRequestDetails(id: 'r2', personToDisplay: person2),
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
    'requests updated, '
    'should update sent and received coaching requests in state',
    build: () => ProfileCoachBloc(),
    act: (bloc) => bloc.add(
      ProfileCoachEventRequestsUpdated(
        sentRequests: [
          CoachingRequestDetails(
            id: 'r1',
            personToDisplay: createPerson(id: 'u1', name: 'name1'),
          ),
          CoachingRequestDetails(
            id: 'r3',
            personToDisplay: createPerson(id: 'u3', name: 'name3'),
          ),
        ],
        receivedRequests: [
          CoachingRequestDetails(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2', name: 'name2'),
          ),
        ],
      ),
    ),
    expect: () => [
      ProfileCoachState(
        status: const BlocStatusComplete(),
        sentCoachingRequests: [
          CoachingRequestDetails(
            id: 'r1',
            personToDisplay: createPerson(id: 'u1', name: 'name1'),
          ),
          CoachingRequestDetails(
            id: 'r3',
            personToDisplay: createPerson(id: 'u3', name: 'name3'),
          ),
        ],
        receivedCoachingRequests: [
          CoachingRequestDetails(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2', name: 'name2'),
          ),
        ],
      ),
    ],
  );

  blocTest(
    'accept request, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => ProfileCoachBloc(
      state: ProfileCoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          CoachingRequestDetails(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestDetails(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(
      const ProfileCoachEventAcceptRequest(requestId: 'r1'),
    ),
    expect: () => [
      ProfileCoachState(
        status: const BlocStatusNoLoggedUser(),
        receivedCoachingRequests: [
          CoachingRequestDetails(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestDetails(
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
    "should call coaching request service's method to delete another requests received by logged user, "
    "should call user repository's method to update logged user with new coach id",
    build: () => ProfileCoachBloc(
      state: ProfileCoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          CoachingRequestDetails(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestDetails(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      coachingRequestService.mockUpdateCoachingRequest();
      coachingRequestService.mockDeleteUnacceptedCoachingRequestsByReceiverId();
      userRepository.mockUpdateUser();
    },
    act: (bloc) => bloc.add(
      const ProfileCoachEventAcceptRequest(requestId: 'r1'),
    ),
    expect: () => [
      ProfileCoachState(
        status: const BlocStatusLoading(),
        receivedCoachingRequests: [
          CoachingRequestDetails(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestDetails(
            id: 'r1',
            personToDisplay: createPerson(id: 'u3'),
          ),
        ],
      ),
      ProfileCoachState(
        status: const BlocStatusComplete<ProfileCoachBlocInfo>(
          info: ProfileCoachBlocInfo.requestAccepted,
        ),
        receivedCoachingRequests: [
          CoachingRequestDetails(
            id: 'r2',
            personToDisplay: createPerson(id: 'u2'),
          ),
          CoachingRequestDetails(
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
        () =>
            coachingRequestService.deleteUnacceptedCoachingRequestsByReceiverId(
          receiverId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => userRepository.updateUser(userId: loggedUserId, coachId: 'u3'),
      ).called(1);
    },
  );

  blocTest(
    'delete request, '
    "should call coaching request service's method to delete request",
    build: () => ProfileCoachBloc(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (bloc) => bloc.add(
      const ProfileCoachEventDeleteRequest(requestId: 'r1'),
    ),
    expect: () => [
      const ProfileCoachState(status: BlocStatusLoading()),
      const ProfileCoachState(
        status: BlocStatusComplete<ProfileCoachBlocInfo>(
          info: ProfileCoachBlocInfo.requestDeleted,
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
    build: () => ProfileCoachBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileCoachEventDeleteCoach()),
    expect: () => [
      const ProfileCoachState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'delete coach, '
    "should call user repository's method to update user with coach id set as null and should emit coachDeleted info",
    build: () => ProfileCoachBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
    },
    act: (bloc) => bloc.add(const ProfileCoachEventDeleteCoach()),
    expect: () => [
      const ProfileCoachState(status: BlocStatusLoading()),
      const ProfileCoachState(
        status: BlocStatusComplete<ProfileCoachBlocInfo>(
          info: ProfileCoachBlocInfo.coachDeleted,
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
}
