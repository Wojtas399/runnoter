import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/user.dart';
import 'package:runnoter/data/repository/user/user_repository.dart';
import 'package:runnoter/data/service/auth/auth_service.dart';
import 'package:runnoter/data/service/coaching_request/coaching_request_service.dart';
import 'package:runnoter/ui/cubit/home/home_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';
import 'package:rxdart/rxdart.dart';

import '../../../creators/user_creator.dart';
import '../../../creators/user_settings_creator.dart';
import '../../../mock/data/repository/mock_user_repository.dart';
import '../../../mock/data/service/mock_auth_service.dart';
import '../../../mock/data/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final coachingRequestService = MockCoachingRequestService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(coachingRequestService);
  });

  group(
    'initialize',
    () {
      final User loggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        name: 'Jack',
        settings: createUserSettings(
          themeMode: ThemeMode.dark,
          language: Language.polish,
          distanceUnit: DistanceUnit.miles,
          paceUnit: PaceUnit.milesPerHour,
        ),
        coachId: 'coach1',
      );
      final User updatedLoggedUser = createUser(
        id: loggedUserId,
        accountType: AccountType.runner,
        name: 'James',
        settings: createUserSettings(
          themeMode: ThemeMode.light,
          language: Language.english,
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.milesPerHour,
        ),
      );
      final StreamController<User?> loggedUser$ =
          BehaviorSubject.seeded(loggedUser);

      blocTest(
        'should listen to logged user data, settings, accepted client requests and '
        'accepted coach request',
        build: () => HomeCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(userStream: loggedUser$.stream);
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          loggedUser$.add(updatedLoggedUser);
        },
        expect: () => [
          const HomeState(status: CubitStatusLoading()),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: loggedUser.accountType,
            loggedUserName: loggedUser.name,
            hasLoggedUserCoach: true,
            userSettings: loggedUser.settings,
          ),
          HomeState(
            status: const CubitStatusComplete(),
            accountType: updatedLoggedUser.accountType,
            loggedUserName: updatedLoggedUser.name,
            hasLoggedUserCoach: false,
            userSettings: updatedLoggedUser.settings,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );

      blocTest(
        'logged user does not exist, '
        'should emit complete status',
        build: () => HomeCubit(),
        setUp: () => authService.mockGetLoggedUserId(),
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const HomeState(status: CubitStatusLoading()),
          const HomeState(status: CubitStatusComplete()),
        ],
        verify: (_) => verify(() => authService.loggedUserId$).called(1),
      );
    },
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
