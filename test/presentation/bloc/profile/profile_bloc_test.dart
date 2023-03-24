import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:runnoter/presentation/screen/profile/bloc/profile_event.dart';
import 'package:runnoter/presentation/screen/profile/bloc/profile_state.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  ProfileBloc createBloc() {
    return ProfileBloc(
      authService: authService,
      userRepository: userRepository,
    );
  }

  ProfileState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? name,
    String? surname,
    String? email,
  }) {
    return ProfileState(
      status: status,
      name: name,
      surname: surname,
      email: email,
    );
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should set listener for logged user email and data',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      authService.mockGetLoggedUserEmail(
        userEmail: 'email@example.com',
      );
      userRepository.mockGetUserById(
        user: createUser(
          name: 'name',
          surname: 'surname',
        ),
      );
    },
    act: (ProfileBloc bloc) {
      bloc.add(
        const ProfileEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: 'email@example.com',
      ),
      createState(
        status: const BlocStatusComplete(),
        name: 'name',
        surname: 'surname',
        email: 'email@example.com',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => authService.loggedUserEmail$,
      ).called(1);
      verify(
        () => userRepository.getUserById(
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'email updated, '
    'should update email in state',
    build: () => createBloc(),
    act: (ProfileBloc bloc) {
      bloc.add(
        const ProfileEventEmailUpdated(
          email: 'email@example.com',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: 'email@example.com',
      ),
    ],
  );

  blocTest(
    'user update, '
    'should update name and surname in state',
    build: () => createBloc(),
    act: (ProfileBloc bloc) {
      bloc.add(
        ProfileEventUserUpdated(
          user: createUser(
            name: 'name',
            surname: 'surname',
          ),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        name: 'name',
        surname: 'surname',
      ),
    ],
  );
}
