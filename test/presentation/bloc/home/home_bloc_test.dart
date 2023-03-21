import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/home/bloc/home_bloc.dart';
import 'package:runnoter/presentation/screen/home/bloc/home_event.dart';
import 'package:runnoter/presentation/screen/home/bloc/home_state.dart';

import '../../../mock/domain/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();

  HomeBloc createBloc() {
    return HomeBloc(
      authService: authService,
    );
  }

  HomeState createState({
    BlocStatus status = const BlocStatusInitial(),
    HomePage currentPage = HomePage.currentWeek,
    String? loggedUserEmail,
  }) {
    return HomeState(
      status: status,
      currentPage: currentPage,
      loggedUserEmail: loggedUserEmail,
    );
  }

  blocTest(
    'initialize, '
    'should set listener on logged user email',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserEmail(
        userEmail: 'user@example.com',
      );
    },
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        loggedUserEmail: 'user@example.com',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserEmail$,
      ).called(1);
    },
  );

  blocTest(
    'logged user email changed, '
    'should update logged user email in state',
    build: () => createBloc(),
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventLoggedUserEmailChanged(
          loggedUserEmail: 'user@example.com',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        loggedUserEmail: 'user@example.com',
      ),
    ],
  );

  blocTest(
    'current page changed, '
    'should update current page in state',
    build: () => createBloc(),
    act: (HomeBloc bloc) {
      bloc.add(
        const HomeEventCurrentPageChanged(
          currentPage: HomePage.calendar,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        currentPage: HomePage.calendar,
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
