import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/blood_test_repository_impl.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';
import 'package:runnoter/domain/entity/blood_test.dart';

import '../../creators/blood_test_creator.dart';
import '../../creators/blood_test_dto_creator.dart';
import '../../mock/firebase/mock_firebase_blood_test_service.dart';

void main() {
  final firebaseBloodTestService = MockFirebaseBloodTestService();
  late BloodTestRepositoryImpl repository;
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseBloodTestService>(
      () => firebaseBloodTestService,
    );
  });

  setUp(
    () => repository = BloodTestRepositoryImpl(),
  );

  tearDown(() {
    reset(firebaseBloodTestService);
  });

  test(
    'get test by id, '
    'blood test exists in repository, '
    'should emit existing blood test',
    () {
      final BloodTest expectedTest = createBloodTest(
        id: 'bt1',
        userId: userId,
        date: DateTime(2023, 5, 21),
      );
      final List<BloodTest> existingTests = [
        expectedTest,
        createBloodTest(id: 'bt2', userId: userId),
        createBloodTest(id: 'bt3', userId: 'u2'),
      ];
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<BloodTest?> test$ = repository.getTestById(
        bloodTestId: 'bt1',
        userId: userId,
      );

      expect(
        test$,
        emitsInOrder([expectedTest]),
      );
    },
  );

  test(
    'get test by id, '
    'blood test does not exist in repository, '
    'should load blood test from remote db and emit it',
    () {
      const String bloodTestId = 'bt1';
      final firebase.BloodTestDto expectedTestDto = createBloodTestDto(
        id: bloodTestId,
        userId: userId,
        date: DateTime(2023, 5, 21),
      );
      final BloodTest expectedTest = createBloodTest(
        id: bloodTestId,
        userId: userId,
        date: DateTime(2023, 5, 21),
      );
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'bt2', userId: userId),
        createBloodTest(id: 'bt3', userId: 'u2'),
      ];
      firebaseBloodTestService.mockLoadTestById(
        bloodTestDto: expectedTestDto,
      );
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<BloodTest?> test$ = repository.getTestById(
        bloodTestId: bloodTestId,
        userId: userId,
      );

      expect(
        test$,
        emitsInOrder([expectedTest]),
      );
    },
  );

  test(
    'get all tests, '
    'should emit tests existing in repository and should load and emit new tests from remote db',
    () async {
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'bt1', userId: userId),
        createBloodTest(id: 'bt2', userId: 'u2'),
        createBloodTest(id: 'bt3', userId: userId),
        createBloodTest(id: 'bt4', userId: 'u3'),
      ];
      final List<firebase.BloodTestDto> loadedTestsDtos = [
        createBloodTestDto(
          id: 'bt5',
          userId: userId,
          date: DateTime(2023, 5, 12),
          parameterResultDtos: const [
            firebase.BloodParameterResultDto(
              parameter: firebase.BloodParameter.ferritin,
              value: 54.1,
            ),
            firebase.BloodParameterResultDto(
              parameter: firebase.BloodParameter.tp,
              value: 6.5,
            ),
          ],
        ),
        createBloodTestDto(
          id: 'bt6',
          userId: userId,
          date: DateTime(2023, 6, 1),
          parameterResultDtos: const [
            firebase.BloodParameterResultDto(
              parameter: firebase.BloodParameter.sodium,
              value: 139,
            ),
          ],
        ),
      ];
      final List<BloodTest> loadedTests = [
        createBloodTest(
          id: 'bt5',
          userId: userId,
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.ferritin,
              value: 54.1,
            ),
            BloodParameterResult(
              parameter: BloodParameter.tp,
              value: 6.5,
            ),
          ],
        ),
        createBloodTest(
          id: 'bt6',
          userId: userId,
          date: DateTime(2023, 6, 1),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.sodium,
              value: 139,
            ),
          ],
        ),
      ];
      firebaseBloodTestService.mockLoadAllTests(
        bloodTestDtos: loadedTestsDtos,
      );
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<List<BloodTest>?> tests$ = repository.getAllTests(
        userId: userId,
      );

      expect(
        await tests$.first,
        [
          existingTests[0],
          existingTests[2],
          ...loadedTests,
        ],
      );
      verify(
        () => firebaseBloodTestService.loadAllTests(
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'add new test, '
    'should call method from firebase service to add new test and should add this test to repository',
    () {
      const String newTestId = 'bt3';
      final DateTime date = DateTime(2023, 5, 20);
      const List<BloodParameterResult> parameterResults = [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
        BloodParameterResult(
          parameter: BloodParameter.sodium,
          value: 139,
        ),
      ];
      const List<firebase.BloodParameterResultDto> parameterResultDtos = [
        firebase.BloodParameterResultDto(
          parameter: firebase.BloodParameter.wbc,
          value: 4.45,
        ),
        firebase.BloodParameterResultDto(
          parameter: firebase.BloodParameter.sodium,
          value: 139,
        ),
      ];
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'bt1', userId: userId),
        createBloodTest(id: 'bt2', userId: 'u2'),
      ];
      final firebase.BloodTestDto addedBloodTestDto = createBloodTestDto(
        id: newTestId,
        date: date,
        userId: userId,
        parameterResultDtos: parameterResultDtos,
      );
      final BloodTest addedBloodTest = createBloodTest(
        id: newTestId,
        userId: userId,
        date: date,
        parameterResults: parameterResults,
      );
      firebaseBloodTestService.mockAddNewTest(
        addedBloodTestDto: addedBloodTestDto,
      );
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<List<BloodTest>?> bloodTests$ = repository.dataStream$;
      bloodTests$.listen((_) {});
      repository.addNewTest(
        userId: userId,
        date: date,
        parameterResults: parameterResults,
      );

      expect(
        bloodTests$,
        emitsInOrder(
          [
            existingTests,
            [
              ...existingTests,
              addedBloodTest,
            ]
          ],
        ),
      );
      verify(
        () => firebaseBloodTestService.addNewTest(
          userId: userId,
          date: date,
          parameterResultDtos: parameterResultDtos,
        ),
      ).called(1);
    },
  );

  test(
    'update test, '
    'should call method from firebase service to update test and should update this test in repository',
    () {
      const String testId = 'bt1';
      final DateTime updatedDate = DateTime(2023, 5, 20);
      const List<BloodParameterResult> updatedParameterResults = [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
        BloodParameterResult(
          parameter: BloodParameter.sodium,
          value: 139,
        ),
      ];
      const List<firebase.BloodParameterResultDto> updatedParameterResultDtos =
          [
        firebase.BloodParameterResultDto(
          parameter: firebase.BloodParameter.wbc,
          value: 4.45,
        ),
        firebase.BloodParameterResultDto(
          parameter: firebase.BloodParameter.sodium,
          value: 139,
        ),
      ];
      final List<BloodTest> existingTests = [
        createBloodTest(
          id: 'bt1',
          userId: userId,
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.cpk,
              value: 300,
            ),
          ],
        ),
        createBloodTest(id: 'bt2', userId: 'u2'),
      ];
      final firebase.BloodTestDto updatedBloodTestDto = createBloodTestDto(
        id: testId,
        date: updatedDate,
        userId: userId,
        parameterResultDtos: updatedParameterResultDtos,
      );
      final BloodTest updatedBloodTest = createBloodTest(
        id: testId,
        userId: userId,
        date: updatedDate,
        parameterResults: updatedParameterResults,
      );
      firebaseBloodTestService.mockUpdateTest(
        updatedBloodTestDto: updatedBloodTestDto,
      );
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<List<BloodTest>?> bloodTests$ = repository.dataStream$;
      bloodTests$.listen((_) {});
      repository.updateTest(
        bloodTestId: testId,
        userId: userId,
        date: updatedDate,
        parameterResults: updatedParameterResults,
      );

      expect(
        bloodTests$,
        emitsInOrder(
          [
            existingTests,
            [
              updatedBloodTest,
              existingTests[1],
            ]
          ],
        ),
      );
      verify(
        () => firebaseBloodTestService.updateTest(
          bloodTestId: testId,
          userId: userId,
          date: updatedDate,
          parameterResultDtos: updatedParameterResultDtos,
        ),
      ).called(1);
    },
  );

  test(
    'delete test, '
    'should call method from firebase service to delete delete test and should delete test from repository',
    () {
      const String bloodTestId = 'bt1';
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'bt1', userId: userId),
        createBloodTest(id: 'bt2', userId: 'u2'),
      ];
      firebaseBloodTestService.mockDeleteTest();
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<List<BloodTest>?> repositoryState$ = repository.dataStream$;
      repository.deleteTest(
        bloodTestId: bloodTestId,
        userId: userId,
      );

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingTests,
            [
              existingTests[1],
            ],
          ],
        ),
      );
      verify(
        () => firebaseBloodTestService.deleteTest(
          bloodTestId: bloodTestId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'delete all user tests, '
    'should call method from firebase service to delete all user tests and should delete these tests from repository',
    () {
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'bt1', userId: userId),
        createBloodTest(id: 'bt2', userId: 'u2'),
        createBloodTest(id: 'bt3', userId: userId),
        createBloodTest(id: 'bt4', userId: 'u2'),
      ];
      firebaseBloodTestService.mockDeleteAllUserTests(
        idsOfDeletedTests: ['bt1', 'bt3'],
      );
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<List<BloodTest>?> repositoryState$ = repository.dataStream$;
      repository.deleteAllUserTests(userId: userId);

      expect(
        repositoryState$,
        emitsInOrder(
          [
            existingTests,
            [
              existingTests[1],
              existingTests.last,
            ],
          ],
        ),
      );
      verify(
        () => firebaseBloodTestService.deleteAllUserTests(
          userId: userId,
        ),
      ).called(1);
    },
  );
}
