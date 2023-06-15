import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';

import '../../../creators/settings_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  HomeBloc createBloc() {
    return HomeBloc(
      authService: authService,
      userRepository: userRepository,
    );
  }

  HomeState createState({
    BlocStatus status = const BlocStatusInitial(),
    DrawerPage drawerPage = DrawerPage.home,
    BottomNavPage bottomNavPage = BottomNavPage.currentWeek,
    String? loggedUserEmail,
    String? loggedUserName,
    String? loggedUserSurname,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) {
    return HomeState(
      status: status,
      drawerPage: drawerPage,
      bottomNavPage: bottomNavPage,
      loggedUserEmail: loggedUserEmail,
      loggedUserName: loggedUserName,
      loggedUserSurname: loggedUserSurname,
      themeMode: themeMode,
      language: language,
      distanceUnit: distanceUnit,
      paceUnit: paceUnit,
    );
  }

  blocTest(
    'initialize, '
    'should set listener of logged user email and logged user data',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserEmail(
        userEmail: 'user@example.com',
      );
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          name: 'name',
          surname: 'surname',
          settings: createSettings(
            themeMode: ThemeMode.dark,
            language: Language.polish,
            distanceUnit: DistanceUnit.miles,
            paceUnit: PaceUnit.milesPerHour,
          ),
        ),
      );
    },
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete(),
        loggedUserEmail: 'user@example.com',
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        themeMode: ThemeMode.dark,
        language: Language.polish,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserEmail$,
      ).called(1);
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
    'listened params changed, '
    "should update logged user's email, name, surname, theme mode, language, distance unit and pace unit in state",
    build: () => createBloc(),
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventListenedParamsChanged(
          listenedParams: HomeStateListenedParams(
            loggedUserEmail: 'email@example.com',
            loggedUserName: 'name',
            loggedUserSurname: 'surname',
            themeMode: ThemeMode.dark,
            language: Language.english,
            distanceUnit: DistanceUnit.miles,
            paceUnit: PaceUnit.milesPerHour,
          ),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        loggedUserEmail: 'email@example.com',
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      ),
    ],
  );

  blocTest(
    'drawer page changed, '
    'should update drawer page in state',
    build: () => createBloc(),
    act: (HomeBloc bloc) => bloc.add(
      const HomeEventDrawerPageChanged(
        drawerPage: DrawerPage.profile,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        drawerPage: DrawerPage.profile,
      ),
    ],
  );

  blocTest(
    'bottom nav page changed, '
    'should update bottom nav page in state',
    build: () => createBloc(),
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventBottomNavPageChanged(
          bottomNavPage: BottomNavPage.calendar,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bottomNavPage: BottomNavPage.calendar,
      ),
    ],
  );

  blocTest(
    'sign out, '
    'should call auth service method to sign out and should emit complete status with user signed out info',
    build: () => createBloc(),
    setUp: () {
      authService.mockSignOut();
    },
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventSignOut(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete(
          info: HomeInfo.userSignedOut,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.signOut(),
      ).called(1);
    },
  );
}
