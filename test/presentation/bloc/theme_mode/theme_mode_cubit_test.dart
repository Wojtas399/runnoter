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
  const String userId = 'u1';

  ThemeModeCubit createCubit({
    ThemeMode? themeMode,
  }) {
    return ThemeModeCubit(
      authService: authService,
      userRepository: userRepository,
      themeMode: themeMode,
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
        userId: userId,
      );
      userRepository.mockGetUserById(
        user: createUser(
          id: userId,
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

  blocTest(
    'update theme mode, '
    "should update theme mode in state and should call method from user repository to update user's settings",
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockUpdateUserSettings();
    },
    act: (ThemeModeCubit cubit) {
      cubit.updateThemeMode(
        themeMode: ThemeMode.system,
      );
    },
    expect: () => [
      ThemeMode.system,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update theme mode, '
    'method from user repository to update settings throws exception, '
    'should set previous theme mode',
    build: () => createCubit(
      themeMode: ThemeMode.dark,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockUpdateUserSettings(
        throwable: 'Exception...',
      );
    },
    act: (ThemeModeCubit cubit) {
      cubit.updateThemeMode(
        themeMode: ThemeMode.system,
      );
    },
    expect: () => [
      ThemeMode.system,
      ThemeMode.dark,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: userId,
          themeMode: ThemeMode.system,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update theme mode, '
    'logged user does not exist, '
    'should finish method call without changing anything',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId();
    },
    act: (ThemeModeCubit cubit) {
      cubit.updateThemeMode(
        themeMode: ThemeMode.system,
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
          themeMode: any(named: 'themeMode'),
        ),
      );
    },
  );
}
