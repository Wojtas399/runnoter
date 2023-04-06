import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/settings.dart';
import 'package:runnoter/presentation/screen/distance_unit/distance_unit_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/settings_creator.dart';
import '../../../util/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String userId = 'u1';

  DistanceUnitCubit createCubit() {
    return DistanceUnitCubit(
      authService: authService,
      userRepository: userRepository,
    );
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should load logged user and should update distance unit in state',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockGetUserById(
        user: createUser(
          settings: createSettings(
            distanceUnit: DistanceUnit.kilometers,
          ),
        ),
      );
    },
    act: (DistanceUnitCubit cubit) {
      cubit.initialize();
    },
    expect: () => [
      DistanceUnit.kilometers,
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
    act: (DistanceUnitCubit cubit) {
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
}
