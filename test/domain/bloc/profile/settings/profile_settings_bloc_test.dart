import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/profile/settings/profile_settings_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../../creators/settings_creator.dart';
import '../../../../creators/user_creator.dart';
import '../../../../mock/domain/repository/mock_user_repository.dart';
import '../../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  ProfileSettingsBloc createBloc({
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) =>
      ProfileSettingsBloc(
        state: ProfileSettingsState(
          status: const BlocStatusInitial(),
          themeMode: themeMode,
          language: language,
          distanceUnit: distanceUnit,
          paceUnit: paceUnit,
        ),
      );

  ProfileSettingsState createState({
    BlocStatus status = const BlocStatusInitial(),
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) =>
      ProfileSettingsState(
        status: status,
        themeMode: themeMode,
        language: language,
        distanceUnit: distanceUnit,
        paceUnit: paceUnit,
      );

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should set listener of logged user',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createRunner(
          settings: createSettings(
            themeMode: ThemeMode.dark,
            language: Language.english,
            distanceUnit: DistanceUnit.kilometers,
            paceUnit: PaceUnit.minutesPerKilometer,
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
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
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateThemeMode(
      newThemeMode: ThemeMode.system,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        themeMode: ThemeMode.system,
      ),
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
    build: () => createBloc(themeMode: ThemeMode.dark),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateThemeMode(
      newThemeMode: ThemeMode.system,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        themeMode: ThemeMode.system,
      ),
      createState(
        status: const BlocStatusComplete(),
        themeMode: ThemeMode.dark,
      ),
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
    'should emit no logged user info',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateThemeMode(
      newThemeMode: ThemeMode.system,
    )),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
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
    build: () => createBloc(themeMode: ThemeMode.system),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateThemeMode(
      newThemeMode: ThemeMode.system,
    )),
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
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateLanguage(
      newLanguage: Language.english,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        language: Language.english,
      ),
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
    build: () => createBloc(language: Language.polish),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateLanguage(
      newLanguage: Language.english,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        language: Language.english,
      ),
      createState(
        status: const BlocStatusComplete(),
        language: Language.polish,
      ),
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
    'should emit no logged user info',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateLanguage(
      newLanguage: Language.english,
    )),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
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
    build: () => createBloc(language: Language.english),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateLanguage(
      newLanguage: Language.english,
    )),
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
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateDistanceUnit(
      newDistanceUnit: DistanceUnit.miles,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        distanceUnit: DistanceUnit.miles,
      ),
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
    build: () => createBloc(distanceUnit: DistanceUnit.kilometers),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateDistanceUnit(
      newDistanceUnit: DistanceUnit.miles,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        distanceUnit: DistanceUnit.miles,
      ),
      createState(
        status: const BlocStatusComplete(),
        distanceUnit: DistanceUnit.kilometers,
      ),
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
    'should emit no logged user info',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateDistanceUnit(
      newDistanceUnit: DistanceUnit.miles,
    )),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
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
    build: () => createBloc(distanceUnit: DistanceUnit.miles),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdateDistanceUnit(
      newDistanceUnit: DistanceUnit.miles,
    )),
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
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings();
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdatePaceUnit(
      newPaceUnit: PaceUnit.kilometersPerHour,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        paceUnit: PaceUnit.kilometersPerHour,
      ),
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
    build: () => createBloc(paceUnit: PaceUnit.milesPerHour),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserSettings(throwable: 'Exception...');
    },
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdatePaceUnit(
      newPaceUnit: PaceUnit.kilometersPerHour,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        paceUnit: PaceUnit.kilometersPerHour,
      ),
      createState(
        status: const BlocStatusComplete(),
        paceUnit: PaceUnit.milesPerHour,
      ),
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
    'should emit no logged user info',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdatePaceUnit(
      newPaceUnit: PaceUnit.kilometersPerHour,
    )),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
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
    build: () => createBloc(paceUnit: PaceUnit.kilometersPerHour),
    act: (bloc) => bloc.add(const ProfileSettingsEventUpdatePaceUnit(
      newPaceUnit: PaceUnit.kilometersPerHour,
    )),
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
