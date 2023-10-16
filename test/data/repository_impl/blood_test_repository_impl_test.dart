import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/blood_test.dart';
import 'package:runnoter/data/model/custom_exception.dart';
import 'package:runnoter/data/repository_impl/blood_test_repository_impl.dart';

import '../../creators/blood_test_creator.dart';
import '../../creators/blood_test_dto_creator.dart';
import '../../mock/firebase/mock_firebase_blood_test_service.dart';

void main() {
  final dbBloodTestService = MockFirebaseBloodTestService();
  late BloodTestRepositoryImpl repository;
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseBloodTestService>(
      () => dbBloodTestService,
    );
  });

  setUp(() => repository = BloodTestRepositoryImpl());

  tearDown(() {
    reset(dbBloodTestService);
  });

  test(
    'getTestById, '
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
    'getTestById, '
    'blood test does not exist in repository, '
    'should load blood test from db and emit it',
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
      dbBloodTestService.mockLoadTestById(
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
    'getTestsByUserId, '
    'should emit tests existing in repository and '
    'should load and emit new tests from db',
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
      dbBloodTestService.mockLoadTestsByUserId(bloodTestDtos: loadedTestsDtos);
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      final Stream<List<BloodTest>?> tests$ = repository.getTestsByUserId(
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
        () => dbBloodTestService.loadTestsByUserId(userId: userId),
      ).called(1);
    },
  );

  test(
    'refreshTestsByUserId, '
    'should load tests by user id from db and should add or update them in repo',
    () async {
      final List<BloodTest> existingTests = [
        createBloodTest(
          id: 't1',
          userId: userId,
          date: DateTime(2023, 1, 10),
        ),
        createBloodTest(
          id: 't2',
          userId: userId,
          date: DateTime(2023, 2, 10),
        ),
        createBloodTest(id: 't3', userId: 'u2'),
      ];
      final List<firebase.BloodTestDto> loadedTestDtos = [
        createBloodTestDto(
          id: 't1',
          userId: userId,
          date: DateTime(2023, 1, 5),
        ),
        createBloodTestDto(
          id: 't4',
          userId: userId,
          date: DateTime(2023, 3, 10),
        ),
      ];
      final List<BloodTest> loadedTests = [
        createBloodTest(
          id: 't1',
          userId: userId,
          date: DateTime(2023, 1, 5),
        ),
        createBloodTest(
          id: 't4',
          userId: userId,
          date: DateTime(2023, 3, 10),
        ),
      ];
      dbBloodTestService.mockLoadTestsByUserId(bloodTestDtos: loadedTestDtos);
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      await repository.refreshTestsByUserId(userId: userId);

      expect(
        repository.dataStream$,
        emits([existingTests.last, ...loadedTests]),
      );
      verify(
        () => dbBloodTestService.loadTestsByUserId(userId: userId),
      ).called(1);
    },
  );

  test(
    'addNewTest, '
    'should add new test to db and repo',
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
      dbBloodTestService.mockAddNewTest(
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
            [...existingTests, addedBloodTest]
          ],
        ),
      );
      verify(
        () => dbBloodTestService.addNewTest(
          userId: userId,
          date: date,
          parameterResultDtos: parameterResultDtos,
        ),
      ).called(1);
    },
  );

  test(
    'updateTest, '
    'should update test in db and repo',
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
      dbBloodTestService.mockUpdateTest(
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
            [updatedBloodTest, existingTests[1]]
          ],
        ),
      );
      verify(
        () => dbBloodTestService.updateTest(
          bloodTestId: testId,
          userId: userId,
          date: updatedDate,
          parameterResultDtos: updatedParameterResultDtos,
        ),
      ).called(1);
    },
  );

  test(
    'updateTest, '
    'db method to update test throws document exception with documentNotFound code, '
    'should delete blood test from repo and should throw entity exception with '
    'entityNotFound code',
    () async {
      const String testId = 'bt1';
      final DateTime updatedDate = DateTime(2023, 5, 20);
      const List<BloodParameterResult> updatedParameterResults = [
        BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
        BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
      ];
      const List<firebase.BloodParameterResultDto> updatedParameterResultDtos =
          [
        firebase.BloodParameterResultDto(
            parameter: firebase.BloodParameter.wbc, value: 4.45),
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
      dbBloodTestService.mockUpdateTest(
        throwable: const firebase.FirebaseDocumentException(
          code: firebase.FirebaseDocumentExceptionCode.documentNotFound,
        ),
      );
      repository = BloodTestRepositoryImpl(initialData: existingTests);

      Object? exception;
      try {
        await repository.updateTest(
          bloodTestId: testId,
          userId: userId,
          date: updatedDate,
          parameterResults: updatedParameterResults,
        );
      } catch (e) {
        exception = e;
      }

      expect(
        exception,
        const EntityException(code: EntityExceptionCode.entityNotFound),
      );
      expect(repository.dataStream$, emits([existingTests[1]]));
      verify(
        () => dbBloodTestService.updateTest(
          bloodTestId: testId,
          userId: userId,
          date: updatedDate,
          parameterResultDtos: updatedParameterResultDtos,
        ),
      ).called(1);
    },
  );

  test(
    'deleteTest, '
    'should delete test from db and repo',
    () {
      const String bloodTestId = 'bt1';
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'bt1', userId: userId),
        createBloodTest(id: 'bt2', userId: 'u2'),
      ];
      dbBloodTestService.mockDeleteTest();
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
            [existingTests[1]],
          ],
        ),
      );
      verify(
        () => dbBloodTestService.deleteTest(
          bloodTestId: bloodTestId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'deleteAllUserTests, '
    'should delete all user tests from db and repo',
    () {
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'bt1', userId: userId),
        createBloodTest(id: 'bt2', userId: 'u2'),
        createBloodTest(id: 'bt3', userId: userId),
        createBloodTest(id: 'bt4', userId: 'u2'),
      ];
      dbBloodTestService.mockDeleteAllUserTests(
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
            [existingTests[1], existingTests.last],
          ],
        ),
      );
      verify(
        () => dbBloodTestService.deleteAllUserTests(userId: userId),
      ).called(1);
    },
  );
}
