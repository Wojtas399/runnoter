import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/blood_tests/blood_tests_cubit.dart';
import 'package:runnoter/domain/repository/blood_test_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final bloodTestRepository = MockBloodTestRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<BloodTestRepository>(bloodTestRepository);
  });

  tearDown(() {
    reset(authService);
    reset(bloodTestRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should finish method call',
    build: () => BloodTestsCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of blood tests grouped by year and sorting by date belonging to logged user',
    build: () => BloodTestsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      bloodTestRepository.mockGetAllTests(
        tests: [
          createBloodTest(
            id: 'br2',
            userId: loggedUserId,
            date: DateTime(2023, 2, 10),
          ),
          createBloodTest(
            id: 'br3',
            userId: loggedUserId,
            date: DateTime(2022, 4, 10),
          ),
          createBloodTest(
            id: 'br1',
            userId: loggedUserId,
            date: DateTime(2023, 5, 20),
          ),
          createBloodTest(
            id: 'br4',
            userId: loggedUserId,
            date: DateTime(2021, 7, 10),
          ),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      [
        BloodTestsFromYear(
          year: 2023,
          bloodTests: [
            createBloodTest(
              id: 'br1',
              userId: loggedUserId,
              date: DateTime(2023, 5, 20),
            ),
            createBloodTest(
              id: 'br2',
              userId: loggedUserId,
              date: DateTime(2023, 2, 10),
            ),
          ],
        ),
        BloodTestsFromYear(
          year: 2022,
          bloodTests: [
            createBloodTest(
              id: 'br3',
              userId: loggedUserId,
              date: DateTime(2022, 4, 10),
            ),
          ],
        ),
        BloodTestsFromYear(
          year: 2021,
          bloodTests: [
            createBloodTest(
              id: 'br4',
              userId: loggedUserId,
              date: DateTime(2021, 7, 10),
            ),
          ],
        ),
      ],
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodTestRepository.getAllTests(
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );
}
