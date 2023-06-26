import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/blood_tests/blood_tests_cubit.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final bloodTestRepository = MockBloodTestRepository();

  BloodTestsCubit createCubit() => BloodTestsCubit(
        authService: authService,
        bloodTestRepository: bloodTestRepository,
      );

  tearDown(() {
    reset(authService);
    reset(bloodTestRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should finish method call',
    build: () => createCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodTestsCubit cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of blood tests grouped by year and sorting by date belonging to logged user',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodTestRepository.mockGetAllTests(
        tests: [
          createBloodTest(
            id: 'br2',
            userId: 'u1',
            date: DateTime(2023, 2, 10),
          ),
          createBloodTest(
            id: 'br3',
            userId: 'u1',
            date: DateTime(2022, 4, 10),
          ),
          createBloodTest(
            id: 'br1',
            userId: 'u1',
            date: DateTime(2023, 5, 20),
          ),
          createBloodTest(
            id: 'br4',
            userId: 'u1',
            date: DateTime(2021, 7, 10),
          ),
        ],
      );
    },
    act: (BloodTestsCubit cubit) => cubit.initialize(),
    expect: () => [
      [
        BloodTestsFromYear(
          year: 2023,
          bloodTests: [
            createBloodTest(
              id: 'br1',
              userId: 'u1',
              date: DateTime(2023, 5, 20),
            ),
            createBloodTest(
              id: 'br2',
              userId: 'u1',
              date: DateTime(2023, 2, 10),
            ),
          ],
        ),
        BloodTestsFromYear(
          year: 2022,
          bloodTests: [
            createBloodTest(
              id: 'br3',
              userId: 'u1',
              date: DateTime(2022, 4, 10),
            ),
          ],
        ),
        BloodTestsFromYear(
          year: 2021,
          bloodTests: [
            createBloodTest(
              id: 'br4',
              userId: 'u1',
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
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
