import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/settings.dart';
import 'package:runnoter/presentation/screen/theme_mode/theme_mode_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/settings_creator.dart';
import '../../../util/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  ThemeModeCubit createCubit() {
    return ThemeModeCubit(
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
    'should load logged user and should update theme mode in state',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          settings: createSettings(
            themeMode: ThemeMode.dark,
          ),
        ),
      );
    },
    act: (ThemeModeCubit cubit) {
      cubit.initialize();
    },
    expect: () => [
      ThemeMode.dark,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.getUserById(
          userId: 'u1',
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
    act: (ThemeModeCubit cubit) {
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
