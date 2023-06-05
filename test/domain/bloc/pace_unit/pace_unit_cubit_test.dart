import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/pace_unit/pace_unit_cubit.dart';
import 'package:runnoter/domain/entity/settings.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../creators/settings_creator.dart';
import '../../../creators/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String userId = 'u1';

  PaceUnitCubit createCubit({
    PaceUnit? paceUnit,
  }) {
    return PaceUnitCubit(
      authService: authService,
      userRepository: userRepository,
      paceUnit: paceUnit,
    );
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should load logged user and should update pace unit in state',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockGetUserById(
        user: createUser(
          settings: createSettings(
            paceUnit: PaceUnit.minutesPerKilometer,
          ),
        ),
      );
    },
    act: (PaceUnitCubit cubit) {
      cubit.initialize();
    },
    expect: () => [
      PaceUnit.minutesPerKilometer,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.getUserById(
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should end initializing process',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId();
    },
    act: (PaceUnitCubit cubit) {
      cubit.initialize();
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.getUserById(
          userId: any(named: 'userId'),
        ),
      );
    },
  );

  blocTest(
    'update pace unit, '
    "should update pace unit in state and should call method from user repository to update user's settings",
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockUpdateUserSettings();
    },
    act: (PaceUnitCubit cubit) {
      cubit.updatePaceUnit(
        newPaceUnit: PaceUnit.kilometersPerHour,
      );
    },
    expect: () => [
      PaceUnit.kilometersPerHour,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: userId,
          paceUnit: PaceUnit.kilometersPerHour,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update pace unit, '
    'method from user repository to update settings throws exception, '
    'should set previous pace unit',
    build: () => createCubit(
      paceUnit: PaceUnit.milesPerHour,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockUpdateUserSettings(
        throwable: 'Exception...',
      );
    },
    act: (PaceUnitCubit cubit) {
      cubit.updatePaceUnit(
        newPaceUnit: PaceUnit.minutesPerKilometer,
      );
    },
    expect: () => [
      PaceUnit.minutesPerKilometer,
      PaceUnit.milesPerHour,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: userId,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update pace unit, '
    'logged user does not exist, '
    'should finish method call without changing anything',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId();
    },
    act: (PaceUnitCubit cubit) {
      cubit.updatePaceUnit(
        newPaceUnit: PaceUnit.milesPerHour,
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: userId,
          paceUnit: any(named: 'paceUnit'),
        ),
      );
    },
  );

  blocTest(
    'update pace unit, '
    'new pace unit is the same as current pace unit, '
    'should do nothing',
    build: () => createCubit(
      paceUnit: PaceUnit.minutesPerKilometer,
    ),
    act: (PaceUnitCubit cubit) {
      cubit.updatePaceUnit(
        newPaceUnit: PaceUnit.minutesPerKilometer,
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => authService.loggedUserId$,
      );
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: any(named: 'userId'),
          paceUnit: any(named: 'paceUnit'),
        ),
      );
    },
  );
}
