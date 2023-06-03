import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/presentation/screen/profile/bloc/profile_settings_bloc.dart';
import 'package:runnoter/presentation/screen/profile/bloc/profile_settings_event.dart';
import 'package:runnoter/presentation/screen/profile/bloc/profile_settings_state.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/settings_creator.dart';
import '../../../util/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  ProfileSettingsBloc createBloc() {
    return ProfileSettingsBloc(
      authService: authService,
      userRepository: userRepository,
    );
  }

  ProfileSettingsState createState({
    BlocStatus status = const BlocStatusInitial(),
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) {
    return ProfileSettingsState(
      status: status,
      themeMode: themeMode,
      language: language,
      distanceUnit: distanceUnit,
      paceUnit: paceUnit,
    );
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should set listener on user',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      userRepository.mockGetUserById(
        user: createUser(
          settings: createSettings(
            themeMode: ThemeMode.dark,
            language: Language.english,
            distanceUnit: DistanceUnit.kilometers,
            paceUnit: PaceUnit.minutesPerKilometer,
          ),
        ),
      );
    },
    act: (ProfileSettingsBloc bloc) {
      bloc.add(
        const ProfileSettingsEventInitialize(),
      );
    },
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
        () => userRepository.getUserById(
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'user updated, '
    'should update all settings params in state',
    build: () => createBloc(),
    act: (ProfileSettingsBloc bloc) {
      bloc.add(
        ProfileSettingsEventUserUpdated(
          user: createUser(
            settings: createSettings(
              themeMode: ThemeMode.dark,
              language: Language.english,
              distanceUnit: DistanceUnit.kilometers,
              paceUnit: PaceUnit.minutesPerKilometer,
            ),
          ),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      ),
    ],
  );
}
