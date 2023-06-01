import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/blood_test_repository_impl.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_test.dart';

import '../../mock/firebase/mock_firebase_blood_test_service.dart';
import '../../util/blood_test_creator.dart';
import '../../util/blood_test_dto_creator.dart';

void main() {
  final firebaseBloodTestService = MockFirebaseBloodTestService();
  late BloodTestRepositoryImpl repository;
  const String userId = 'u1';

  BloodTestRepositoryImpl createRepository({
    List<BloodTest>? initialState,
  }) =>
      BloodTestRepositoryImpl(
        firebaseBloodTestService: firebaseBloodTestService,
        initialData: initialState,
      );

  tearDown(() {
    reset(firebaseBloodTestService);
  });

  test(
    'get all tests, '
    'should emit tests existing in repository and should load and emit new tests from remote db',
    () async {
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'br1', userId: userId),
        createBloodTest(id: 'br2', userId: 'u2'),
        createBloodTest(id: 'br3', userId: userId),
        createBloodTest(id: 'br4', userId: 'u3'),
      ];
      final List<firebase.BloodTestDto> loadedTestsDtos = [
        createBloodTestDto(
          id: 'br5',
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
          id: 'br6',
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
          id: 'br5',
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
          id: 'br6',
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
      repository = createRepository(initialState: existingTests);

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
      const String newTestId = 'br3';
      final DateTime newTestDate = DateTime(2023, 5, 20);
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
      final List<BloodTest> existingTests = [
        createBloodTest(id: 'br1', userId: userId),
        createBloodTest(id: 'br2', userId: 'u2'),
      ];
      final firebase.BloodTestDto addedBloodTestDto = createBloodTestDto(
        id: newTestId,
        date: newTestDate,
        userId: userId,
        parameterResultDtos: const [
          firebase.BloodParameterResultDto(
            parameter: firebase.BloodParameter.wbc,
            value: 4.45,
          ),
          firebase.BloodParameterResultDto(
            parameter: firebase.BloodParameter.sodium,
            value: 139,
          ),
        ],
      );
      final BloodTest addedBloodTest = createBloodTest(
        id: newTestId,
        userId: userId,
        date: newTestDate,
        parameterResults: parameterResults,
      );
      firebaseBloodTestService.mockAddNewTest(
        addedBloodTestDto: addedBloodTestDto,
      );
      repository = createRepository(initialState: existingTests);

      final Stream<List<BloodTest>?> bloodTests$ = repository.dataStream$;
      bloodTests$.listen((_) {});
      repository.addNewTest(
        userId: userId,
        date: newTestDate,
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
    },
  );
}
