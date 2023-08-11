import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/clients_cubit.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../mock/domain/repository/mock_person_repository.dart';
import '../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final personRepository = MockPersonRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerLazySingleton<PersonRepository>(() => personRepository);
  });

  tearDown(() {
    reset(authService);
    reset(personRepository);
  });

  blocTest(
    'initialize, '
    'should get persons by coach id from person repository and should emit them',
    build: () => ClientsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: const [
          Person(
            id: 'u3',
            gender: Gender.female,
            name: 'Elizabeth',
            surname: 'Bobsly',
            email: 'elizabeth.bobsly@example.com',
          ),
          Person(
            id: 'u4',
            gender: Gender.female,
            name: 'Elizabeth',
            surname: 'Bugly',
            email: 'elizabeth.bug@example.com',
          ),
          Person(
            id: 'u2',
            gender: Gender.male,
            name: 'Jack',
            surname: 'Novosilsky',
            email: 'jack.nov@example.com',
          ),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const [
        Person(
          id: 'u3',
          gender: Gender.female,
          name: 'Elizabeth',
          surname: 'Bobsly',
          email: 'elizabeth.bobsly@example.com',
        ),
        Person(
          id: 'u4',
          gender: Gender.female,
          name: 'Elizabeth',
          surname: 'Bugly',
          email: 'elizabeth.bug@example.com',
        ),
        Person(
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
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'method to get persons by coach id emits null, '
    'should emit empty array in state',
    build: () => ClientsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(persons: null);
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [const []],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
    },
  );
}
