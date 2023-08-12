import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/coach/coach_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

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
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => CoachBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const CoachEventInitialize()),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'logged user has a coach, '
    'should load coach and update coach param in state',
    build: () => CoachBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(id: loggedUserId, coachId: 'c1'),
      );
      personRepository.mockGetPersonById(
        person: createPerson(
          id: 'c1',
          gender: Gender.male,
          name: 'name1',
          surname: 'surname1',
          email: 'email1@example.com',
        ),
      );
      coachingRequestService.mockGetCoachingRequestsByReceiverId(requests: []);
    },
    act: (bloc) => bloc.add(const CoachEventInitialize()),
    expect: () => [
      CoachState(
        status: const BlocStatusComplete(),
        coach: createPerson(
          id: 'c1',
          gender: Gender.male,
          name: 'name1',
          surname: 'surname1',
          email: 'email1@example.com',
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
      verify(() => personRepository.getPersonById(personId: 'c1')).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user does not have a coach, '
    'should load and emit all received coaching requests',
    build: () => CoachBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(user: createUser(id: loggedUserId));
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requests: [
          createCoachingRequest(id: 'i1', senderId: 'u2', isAccepted: false),
          createCoachingRequest(id: 'i2', senderId: 'u3', isAccepted: false),
          createCoachingRequest(id: 'i3', senderId: 'u4', isAccepted: true),
        ],
      );
      when(
        () => personRepository.getPersonById(personId: 'u2'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u2', name: 'name2')));
      when(
        () => personRepository.getPersonById(personId: 'u3'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u3', name: 'name3')));
    },
    act: (bloc) => bloc.add(const CoachEventInitialize()),
    expect: () => [
      CoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          CoachingRequestInfo(
            id: 'i1',
            sender: createPerson(id: 'u2', name: 'name2'),
          ),
          CoachingRequestInfo(
            id: 'i2',
            sender: createPerson(id: 'u3', name: 'name3'),
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsByReceiverId(
          receiverId: loggedUserId,
        ),
      ).called(1);
      verify(() => personRepository.getPersonById(personId: 'u2')).called(1);
      verify(() => personRepository.getPersonById(personId: 'u3')).called(1);
    },
  );

  blocTest(
    'accept request, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => CoachBloc(
      state: CoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
        ],
      ),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const CoachEventAcceptRequest(requestId: 'r1')),
    expect: () => [
      CoachState(
        status: const BlocStatusNoLoggedUser(),
        receivedCoachingRequests: [
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
        ],
      ),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'accept request, '
    "should call coaching request service's method to update request with isAccepted param set as true and should call user repository's method to update logged user with new coach id",
    build: () => CoachBloc(
      state: CoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
      coachingRequestService.mockUpdateCoachingRequest();
    },
    act: (bloc) => bloc.add(const CoachEventAcceptRequest(requestId: 'r1')),
    expect: () => [
      CoachState(
        status: const BlocStatusLoading(),
        receivedCoachingRequests: [
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
        ],
      ),
      CoachState(
        status: const BlocStatusComplete<CoachBlocInfo>(
          info: CoachBlocInfo.requestAccepted,
        ),
        receivedCoachingRequests: [
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUser(userId: loggedUserId, coachId: 'u3'),
      ).called(1);
      verify(
        () => coachingRequestService.updateCoachingRequest(
          requestId: 'r1',
          isAccepted: true,
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete request, '
    "should call coaching request service's method to delete request",
    build: () => CoachBloc(),
    setUp: () => coachingRequestService.mockDeleteCoachingRequest(),
    act: (bloc) => bloc.add(const CoachEventDeleteRequest(requestId: 'r1')),
    expect: () => [
      const CoachState(status: BlocStatusLoading()),
      const CoachState(status: BlocStatusComplete<CoachBlocInfo>()),
    ],
    verify: (_) => verify(
      () => coachingRequestService.deleteCoachingRequest(requestId: 'r1'),
    ).called(1),
  );
}
