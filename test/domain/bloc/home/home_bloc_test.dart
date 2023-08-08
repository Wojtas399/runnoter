import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';
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

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    ;
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  blocTest(
    'initialize, '
    "should set listener of logged user's data",
    build: () => HomeBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(
          id: loggedUserId,
          accountType: AccountType.runner,
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
      const HomeState(status: BlocStatusLoading()),
      HomeState(
        status: const BlocStatusComplete(),
        accountType: AccountType.runner,
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
      verify(() => authService.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
    },
  );

  blocTest(
    'sign out, '
    'should call auth service method to sign out and should emit signed out info',
    build: () => HomeBloc(),
    setUp: () => authService.mockSignOut(),
    act: (bloc) => bloc.add(const HomeEventSignOut()),
    expect: () => [
      const HomeState(status: BlocStatusLoading()),
      const HomeState(
        status: BlocStatusComplete(info: HomeBlocInfo.userSignedOut),
      ),
    ],
    verify: (_) => verify(authService.signOut).called(1),
  );
}
