import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/profile/coach/profile_coach_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
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
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileCoachBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileCoachEventInitialize()),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'logged user has a coach, '
    'should load coach and update coach param in state',
    build: () => ProfileCoachBloc(),
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
    act: (bloc) => bloc.add(const ProfileCoachEventInitialize()),
    expect: () => [
      ProfileCoachState(
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
    build: () => ProfileCoachBloc(),
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
    act: (bloc) => bloc.add(const ProfileCoachEventInitialize()),
    expect: () => [
      ProfileCoachState(
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
    build: () => ProfileCoachBloc(
      state: ProfileCoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
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
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
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
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
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
          CoachingRequestInfo(id: 'r2', sender: createPerson(id: 'u2')),
          CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u3')),
        ],
      ),
      ProfileCoachState(
        status: const BlocStatusComplete<ProfileCoachBlocInfo>(
          info: ProfileCoachBlocInfo.requestAccepted,
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