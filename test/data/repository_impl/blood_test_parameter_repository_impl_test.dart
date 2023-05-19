import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/blood_test_parameter_repository_impl.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';

import '../../mock/firebase/mock_firebase_blood_test_parameter_service.dart';
import '../../util/blood_test_parameter_creator.dart';
import '../../util/blood_test_parameter_dto_creator.dart';

void main() {
  final firebaseBloodTestParameterService =
      MockFirebaseBloodTestParameterService();
  late BloodTestParameterRepositoryImpl repository;

  BloodTestParameterRepositoryImpl createRepository({
    List<BloodTestParameter>? initialState,
  }) =>
      BloodTestParameterRepositoryImpl(
        firebaseBloodTestParameterService: firebaseBloodTestParameterService,
        initialState: initialState,
      );

  setUp(() => repository = createRepository());

  test(
    'get all parameters, '
    'should emit parameters existing in repository, should load new parameters from firebase and should emit them',
    () {
      final List<BloodTestParameter> existingParameters = [
        createBloodTestParameter(
          id: 'p1',
          type: BloodTestParameterType.basic,
          name: 'parameter 1',
          unit: BloodTestParameterUnit.millimolesPerLitre,
          norm: const BloodTestParameterNorm(min: 2, max: 10.2),
          description: 'this is parameter 1',
        ),
        createBloodTestParameter(
          id: 'p2',
          type: BloodTestParameterType.basic,
          name: 'parameter 2',
          unit: BloodTestParameterUnit.gramsPerDecilitre,
          norm: const BloodTestParameterNorm(min: 3, max: 15),
          description: 'this is parameter 2',
        ),
        createBloodTestParameter(
          id: 'p3',
          type: BloodTestParameterType.additional,
          name: 'parameter 3',
          unit: BloodTestParameterUnit.milligramsPerDecilitre,
          norm: const BloodTestParameterNorm(min: 25, max: 50),
          description: 'this is parameter 3',
        ),
      ];
      final List<firebase.BloodTestParameterDto> newParameterDtos = [
        createBloodTestParameterDto(
          id: 'p4',
          type: firebase.BloodTestParameterType.basic,
          name: 'parameter 4',
          unit: firebase.BloodTestParameterUnit.femtolitre,
          normDto: const firebase.BloodTestParameterNormDto(min: 70, max: 100),
          description: 'this is parameter 4',
        ),
        createBloodTestParameterDto(
          id: 'p5',
          type: firebase.BloodTestParameterType.additional,
          name: 'parameter 5',
          unit: firebase.BloodTestParameterUnit.milligramsPerDecilitre,
          normDto: const firebase.BloodTestParameterNormDto(min: 80, max: 110),
          description: 'this is parameter 5',
        ),
      ];
      final List<BloodTestParameter> newParameters = [
        createBloodTestParameter(
          id: 'p4',
          type: BloodTestParameterType.basic,
          name: 'parameter 4',
          unit: BloodTestParameterUnit.femtolitre,
          norm: const BloodTestParameterNorm(min: 70, max: 100),
          description: 'this is parameter 4',
        ),
        createBloodTestParameter(
          id: 'p5',
          type: BloodTestParameterType.additional,
          name: 'parameter 5',
          unit: BloodTestParameterUnit.milligramsPerDecilitre,
          norm: const BloodTestParameterNorm(min: 80, max: 110),
          description: 'this is parameter 5',
        ),
      ];
      firebaseBloodTestParameterService.mockLoadAllParameters(
        parameterDtos: newParameterDtos,
      );
      repository = createRepository(initialState: existingParameters);

      final Stream<List<BloodTestParameter>?> parameters$ =
          repository.getAllParameters();
      parameters$.listen((_) {});

      expect(
        parameters$,
        emitsInOrder(
          [
            existingParameters,
            [
              ...existingParameters,
              ...newParameters,
            ]
          ],
        ),
      );
      verify(
        () => firebaseBloodTestParameterService.loadAllParameters(),
      ).called(1);
    },
  );
}
