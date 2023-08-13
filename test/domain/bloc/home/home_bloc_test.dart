import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../creators/settings_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(coachingRequestService);
    reset(personRepository);
  });

  blocTest(
    'initialize, '
    'there are no sent coaching requests, '
    'should emit new clients as empty array',
    build: () => HomeBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(
          id: loggedUserId,
          accountType: AccountType.runner,
          name: 'Jack',
          settings: createSettings(
            themeMode: ThemeMode.dark,
            language: Language.polish,
            distanceUnit: DistanceUnit.miles,
            paceUnit: PaceUnit.milesPerHour,
          ),
        ),
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(requests: []);
    },
    act: (bloc) => bloc.add(const HomeEventInitialize()),
    expect: () => [
      const HomeState(status: BlocStatusLoading()),
      HomeState(
        status: const BlocStatusComplete(),
        accountType: AccountType.runner,
        loggedUserName: 'Jack',
        appSettings: createSettings(
          themeMode: ThemeMode.dark,
          language: Language.polish,
          distanceUnit: DistanceUnit.miles,
          paceUnit: PaceUnit.milesPerHour,
        ),
        newClients: [],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    "should set listener of logged user's data and new clients",
    build: () => HomeBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(
          id: loggedUserId,
          accountType: AccountType.runner,
          name: 'Jack',
          settings: createSettings(
            themeMode: ThemeMode.dark,
            language: Language.polish,
            distanceUnit: DistanceUnit.miles,
            paceUnit: PaceUnit.milesPerHour,
          ),
        ),
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [
          createCoachingRequest(id: 'r1', receiverId: 'u2', isAccepted: true),
          createCoachingRequest(id: 'r2', receiverId: 'u3', isAccepted: false),
          createCoachingRequest(id: 'r3', receiverId: 'u4', isAccepted: true),
        ],
      );
      when(
        () => personRepository.getPersonById(personId: 'u2'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u2', name: 'name2')));
      when(
        () => personRepository.getPersonById(personId: 'u4'),
      ).thenAnswer((_) => Stream.value(createPerson(id: 'u4', name: 'name4')));
    },
    act: (bloc) => bloc.add(const HomeEventInitialize()),
    expect: () => [
      const HomeState(status: BlocStatusLoading()),
      HomeState(
        status: const BlocStatusComplete(),
        accountType: AccountType.runner,
        loggedUserName: 'Jack',
        appSettings: createSettings(
          themeMode: ThemeMode.dark,
          language: Language.polish,
          distanceUnit: DistanceUnit.miles,
          paceUnit: PaceUnit.milesPerHour,
        ),
        newClients: [
          createPerson(id: 'u2', name: 'name2'),
          createPerson(id: 'u4', name: 'name4'),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
        ),
      ).called(1);
      verify(() => personRepository.getPersonById(personId: 'u2')).called(1);
      verify(() => personRepository.getPersonById(personId: 'u4')).called(1);
    },
  );

  blocTest(
    'delete accepted coaching requests, '
    'logged user does not exist, '
    'should finish event call',
    build: () => HomeBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const HomeEventDeleteAcceptedCoachingRequests()),
    expect: () => [],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verifyNever(
        () => coachingRequestService.deleteAcceptedCoachingRequestsBySenderId(
          senderId: loggedUserId,
        ),
      );
    },
  );

  blocTest(
    'delete accepted coaching requests, '
    "should call coaching request service's method to delete all accepted requests sent by logged user",
    build: () => HomeBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      coachingRequestService.mockDeleteAcceptedCoachingRequestsBySenderId();
    },
    act: (bloc) => bloc.add(const HomeEventDeleteAcceptedCoachingRequests()),
    expect: () => [],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => coachingRequestService.deleteAcceptedCoachingRequestsBySenderId(
          senderId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'sign out, '
    'should call auth service method to sign out and should emit signed out info',
    build: () => HomeBloc(),
    setUp: () => authService.mockSignOut(),
    act: (bloc) => bloc.add(const HomeEventSignOut()),
    expect: () => [
      const HomeState(status: BlocStatusLoading()),
      const HomeState(
        status: BlocStatusComplete(info: HomeBlocInfo.userSignedOut),
      ),
    ],
    verify: (_) => verify(authService.signOut).called(1),
  );
}
