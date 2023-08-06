import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/settings_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  HomeState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? loggedUserName,
    Settings? appSettings,
  }) {
    return HomeState(
      status: status,
      loggedUserName: loggedUserName,
      appSettings: appSettings,
    );
  }

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  blocTest(
    'initialize, '
    "should set listener of logged user's data",
    build: () => HomeBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createRunner(
          id: loggedUserId,
          name: 'Jack',
          settings: createSettings(
            themeMode: ThemeMode.dark,
            language: Language.polish,
            distanceUnit: DistanceUnit.miles,
            paceUnit: PaceUnit.milesPerHour,
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(const HomeEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete(),
        loggedUserName: 'Jack',
        appSettings: createSettings(
          themeMode: ThemeMode.dark,
          language: Language.polish,
          distanceUnit: DistanceUnit.miles,
          paceUnit: PaceUnit.milesPerHour,
        ),
      ),
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
    'sign out, '
    'should call auth service method to sign out and should emit signed out info',
    build: () => HomeBloc(),
    setUp: () => authService.mockSignOut(),
    act: (bloc) => bloc.add(const HomeEventSignOut()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete(info: HomeBlocInfo.userSignedOut),
      ),
    ],
    verify: (_) => verify(
      () => authService.signOut(),
    ).called(1),
  );
}
