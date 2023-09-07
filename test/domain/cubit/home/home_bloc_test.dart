import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/cubit/home/home_cubit.dart';
import 'package:runnoter/domain/entity/person.dart';
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
      final StreamController<User?> loggedUserData$ = StreamController()
        ..add(loggedUserData);
      final StreamController<List<CoachingRequest>> clientsRequests$ =
          StreamController()..add(requestsSentToClients);
      final StreamController<List<CoachingRequest>> coachesRequests$ =
          StreamController()..add(requestsSentToCoaches);
      final List<CoachingRequestShort> acceptedClientRequests = [
        CoachingRequestShort(id: 'r2', personToDisplay: client1),
        CoachingRequestShort(id: 'r3', personToDisplay: client2),
      ];

      blocTest(
        "should set listener of logged user's data, accepted client requests and accepted coach request",
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
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          coachesRequests$.add([]);
          await cubit.stream.first;
          clientsRequests$.add([]);
          await cubit.stream.first;
          loggedUserData$.add(updatedLoggedUserData);
        },
        expect: () => [
          const HomeState(status: BlocStatusLoading()),
          HomeState(
            status: const BlocStatusComplete(),
            accountType: loggedUserData.accountType,
            loggedUserName: loggedUserData.name,
            appSettings: loggedUserData.settings,
            acceptedClientRequests: acceptedClientRequests,
            acceptedCoachRequest: CoachingRequestShort(
              id: 'r4',
              personToDisplay: coach,
            ),
          ),
          HomeState(
            status: const BlocStatusComplete(),
            accountType: loggedUserData.accountType,
            loggedUserName: loggedUserData.name,
            appSettings: loggedUserData.settings,
            acceptedClientRequests: acceptedClientRequests,
          ),
          HomeState(
            status: const BlocStatusComplete(),
            accountType: loggedUserData.accountType,
            loggedUserName: loggedUserData.name,
            appSettings: loggedUserData.settings,
            acceptedClientRequests: const [],
          ),
          HomeState(
            status: const BlocStatusComplete(),
            accountType: updatedLoggedUserData.accountType,
            loggedUserName: updatedLoggedUserData.name,
            appSettings: updatedLoggedUserData.settings,
            acceptedClientRequests: const [],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
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
        },
      );

      blocTest(
        'logged user does not exist, '
        'should emit no logged user status',
        build: () => HomeCubit(),
        setUp: () => authService.mockGetLoggedUserId(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(status: BlocStatusLoading()),
          const HomeState(status: BlocStatusNoLoggedUser()),
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
      const HomeState(status: BlocStatusLoading()),
      const HomeState(
        status: BlocStatusComplete(info: HomeCubitInfo.userSignedOut),
      ),
    ],
    verify: (_) => verify(authService.signOut).called(1),
  );
}
