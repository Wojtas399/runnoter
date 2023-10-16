import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/user_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/model/user.dart';
import 'package:runnoter/ui/cubit/profile/settings/profile_settings_cubit.dart';

import '../../../../creators/user_creator.dart';
import '../../../../creators/user_settings_creator.dart';
import '../../../../mock/domain/repository/mock_user_repository.dart';
import '../../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should set listener of logged user settings',
    build: () => ProfileSettingsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(
          settings: createUserSettings(
            themeMode: ThemeMode.dark,
            language: Language.english,
            distanceUnit: DistanceUnit.kilometers,
            paceUnit: PaceUnit.minutesPerKilometer,
          ),
        ),
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const ProfileSettingsState(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      )
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.getUserById(userId: loggedUserId),
      ).called(1);
    },
  );

  blocTest(
    'update theme mode, '
    "should update theme mode in state and should call method from user repository to update user's settings with new theme mode",
    build: () => ProfileSettingsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (cubit) => cubit.updateThemeMode(ThemeMode.system),
    expect: () => [
      const ProfileSettingsState(themeMode: ThemeMode.system),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          themeMode: ThemeMode.system,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update theme mode, '
    'method from user repository to update settings throws exception, '
    'should set previous theme mode',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(themeMode: ThemeMode.dark),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (cubit) => cubit.updateThemeMode(ThemeMode.system),
    expect: () => [
      const ProfileSettingsState(themeMode: ThemeMode.system),
      const ProfileSettingsState(themeMode: ThemeMode.dark),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          themeMode: ThemeMode.system,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update theme mode, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileSettingsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateThemeMode(ThemeMode.system),
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          themeMode: any(named: 'themeMode'),
        ),
      );
    },
  );

  blocTest(
    'update theme mode, '
    'new theme mode is the same as current theme mode, '
    'should do nothing',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(themeMode: ThemeMode.system),
    ),
    act: (cubit) => cubit.updateThemeMode(ThemeMode.system),
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => authService.loggedUserId$,
      );
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: any(named: 'userId'),
          themeMode: any(named: 'themeMode'),
        ),
      );
    },
  );

  blocTest(
    'update language, '
    "should update language in state and should call method from user repository to update user's settings with new language",
    build: () => ProfileSettingsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (cubit) => cubit.updateLanguage(Language.english),
    expect: () => [
      const ProfileSettingsState(language: Language.english),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          language: Language.english,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update language, '
    "method from user repository to update user's settings throws exception, "
    'should set previous language',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(language: Language.polish),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (cubit) => cubit.updateLanguage(Language.english),
    expect: () => [
      const ProfileSettingsState(language: Language.english),
      const ProfileSettingsState(language: Language.polish),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          language: Language.english,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update language, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileSettingsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateLanguage(Language.english),
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          language: any(named: 'language'),
        ),
      );
    },
  );

  blocTest(
    'update language, '
    'new language is the same as current language, '
    'should do nothing',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(language: Language.english),
    ),
    act: (cubit) => cubit.updateLanguage(Language.english),
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => authService.loggedUserId$,
      );
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: any(named: 'userId'),
          language: any(named: 'language'),
        ),
      );
    },
  );

  blocTest(
    'update distance unit, '
    "should update distance unit in state and should call method from user repository to update user's settings with new distance unit",
    build: () => ProfileSettingsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (cubit) => cubit.updateDistanceUnit(DistanceUnit.miles),
    expect: () => [
      const ProfileSettingsState(distanceUnit: DistanceUnit.miles),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          distanceUnit: DistanceUnit.miles,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update distance unit, '
    'method from user repository to update settings throws exception, '
    'should set previous distance unit',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(
        distanceUnit: DistanceUnit.kilometers,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (cubit) => cubit.updateDistanceUnit(DistanceUnit.miles),
    expect: () => [
      const ProfileSettingsState(distanceUnit: DistanceUnit.miles),
      const ProfileSettingsState(distanceUnit: DistanceUnit.kilometers),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          distanceUnit: DistanceUnit.miles,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update distance unit, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileSettingsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateDistanceUnit(DistanceUnit.miles),
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          distanceUnit: any(named: 'distanceUnit'),
        ),
      );
    },
  );

  blocTest(
    'update distance unit, '
    'new distance unit is the same as current distance unit, '
    'should do nothing',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(
        distanceUnit: DistanceUnit.miles,
      ),
    ),
    act: (cubit) => cubit.updateDistanceUnit(DistanceUnit.miles),
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => authService.loggedUserId$,
      );
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: any(named: 'userId'),
          distanceUnit: any(named: 'distanceUnit'),
        ),
      );
    },
  );

  blocTest(
    'update pace unit, '
    "should update pace unit in state and should call method from user repository to update user's settings with new pace unit",
    build: () => ProfileSettingsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (cubit) => cubit.updatePaceUnit(PaceUnit.kilometersPerHour),
    expect: () => [
      const ProfileSettingsState(paceUnit: PaceUnit.kilometersPerHour),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          paceUnit: PaceUnit.kilometersPerHour,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update pace unit, '
    'method from user repository to update settings throws exception, '
    'should set previous pace unit',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(paceUnit: PaceUnit.milesPerHour),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (cubit) => cubit.updatePaceUnit(PaceUnit.kilometersPerHour),
    expect: () => [
      const ProfileSettingsState(paceUnit: PaceUnit.kilometersPerHour),
      const ProfileSettingsState(paceUnit: PaceUnit.milesPerHour),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          paceUnit: PaceUnit.kilometersPerHour,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update pace unit, '
    'logged user does not exist, '
    'should do nothing',
    build: () => ProfileSettingsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updatePaceUnit(PaceUnit.kilometersPerHour),
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: loggedUserId,
          paceUnit: any(named: 'paceUnit'),
        ),
      );
    },
  );

  blocTest(
    'update pace unit, '
    'new pace unit is the same as current pace unit, '
    'should do nothing',
    build: () => ProfileSettingsCubit(
      initialState: const ProfileSettingsState(
        paceUnit: PaceUnit.kilometersPerHour,
      ),
    ),
    act: (cubit) => cubit.updatePaceUnit(PaceUnit.kilometersPerHour),
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
