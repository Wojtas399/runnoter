import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/settings.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/home/bloc/home_bloc.dart';
import 'package:runnoter/presentation/screen/home/bloc/home_event.dart';
import 'package:runnoter/presentation/screen/home/bloc/home_state.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/settings_creator.dart';
import '../../../util/user_creator.dart';

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
    );
  }

  blocTest(
    'initialize, '
    'should set listener on logged user email and logged user data',
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
    "should update logged user's email, name, surname, theme mode and language in state",
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
