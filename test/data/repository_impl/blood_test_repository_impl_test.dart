import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/blood_test_repository_impl.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';

import '../../mock/firebase/mock_firebase_blood_test_parameter_service.dart';
import '../../util/blood_test_parameter_creator.dart';
import '../../util/blood_test_parameter_dto_creator.dart';

void main() {
  final firebaseBloodTestParameterService =
      MockFirebaseBloodTestParameterService();
  late BloodTestRepositoryImpl repository;

  BloodTestRepositoryImpl createRepository() => BloodTestRepositoryImpl(
        firebaseBloodTestParameterService: firebaseBloodTestParameterService,
      );

  setUp(() => repository = createRepository());

  test(
    'load all parameters, '
    'should load and return parameters from remote db',
    () async {
      final List<firebase.BloodTestParameterDto> expectedParameterDtos = [
        createBloodTestParameterDto(
          id: 'p1',
          type: firebase.BloodTestParameterType.basic,
          name: 'parameter 1',
          unit: firebase.BloodTestParameterUnit.femtolitre,
          normDto: const firebase.BloodTestParameterNormDto(min: 70, max: 100),
          description: 'this is parameter 1',
        ),
        createBloodTestParameterDto(
          id: 'p2',
          type: firebase.BloodTestParameterType.additional,
          name: 'parameter 2',
          unit: firebase.BloodTestParameterUnit.milligramsPerDecilitre,
          normDto: const firebase.BloodTestParameterNormDto(min: 80, max: 110),
          description: 'this is parameter 2',
        ),
      ];
      final List<BloodTestParameter> expectedParameters = [
        createBloodTestParameter(
          id: 'p1',
          type: BloodTestParameterType.basic,
          name: 'parameter 1',
          unit: BloodTestParameterUnit.femtolitre,
          norm: const BloodTestParameterNorm(min: 70, max: 100),
          description: 'this is parameter 1',
        ),
        createBloodTestParameter(
          id: 'p2',
          type: BloodTestParameterType.additional,
          name: 'parameter 2',
          unit: BloodTestParameterUnit.milligramsPerDecilitre,
          norm: const BloodTestParameterNorm(min: 80, max: 110),
          description: 'this is parameter 2',
        ),
      ];
      firebaseBloodTestParameterService.mockLoadAllParameters(
        parameterDtos: expectedParameterDtos,
      );

      final List<BloodTestParameter>? parameters =
          await repository.loadAllParameters();

      expect(parameters, expectedParameters);
      verify(
        () => firebaseBloodTestParameterService.loadAllParameters(),
      ).called(1);
    },
  );
}
