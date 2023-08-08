import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/clients/clients_cubit.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerLazySingleton<UserRepository>(() => userRepository);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should get users by coach id from user repository and should map them to client models sorted by surname',
    build: () => ClientsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUsersByCoachId(
        users: [
          createUser(
            id: 'u2',
            coachId: loggedUserId,
            gender: Gender.male,
            name: 'Jack',
            surname: 'Novosilsky',
            email: 'jack.nov@example.com',
          ),
          createUser(
            id: 'u3',
            coachId: loggedUserId,
            gender: Gender.female,
            name: 'Elizabeth',
            surname: 'Bobsly',
            email: 'elizabeth.bobsly@example.com',
          ),
          createUser(
            id: 'u4',
            coachId: loggedUserId,
            gender: Gender.female,
            name: 'Elizabeth',
            surname: 'Bugly',
            email: 'elizabeth.bug@example.com',
          ),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const [
        Client(
          id: 'u3',
          gender: Gender.female,
          name: 'Elizabeth',
          surname: 'Bobsly',
          email: 'elizabeth.bobsly@example.com',
        ),
        Client(
          id: 'u4',
          gender: Gender.female,
          name: 'Elizabeth',
          surname: 'Bugly',
          email: 'elizabeth.bug@example.com',
        ),
        Client(
          id: 'u2',
          gender: Gender.male,
          name: 'Jack',
          surname: 'Novosilsky',
          email: 'jack.nov@example.com',
        ),
      ],
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.getUsersByCoachId(coachId: loggedUserId),
      ).called(1);
    },
  );
}
