import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_test_creator/bloc/blood_test_creator_bloc.dart';

import '../../../mock/domain/mock_blood_test_repository.dart';
import '../../../util/blood_test_parameter_creator.dart';

void main() {
  final bloodTestRepository = MockBloodTestRepository();

  BloodTestCreatorBloc createBloc() => BloodTestCreatorBloc(
        bloodTestRepository: bloodTestRepository,
      );

  BloodTestCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    List<BloodTestParameter>? parameters,
  }) =>
      BloodTestCreatorState(
        status: status,
        parameters: parameters,
      );

  tearDown(() {
    reset(bloodTestRepository);
  });

  blocTest(
    'initialize, '
    'should load blood test parameters from blood test repository and should update them in state',
    build: () => createBloc(),
    setUp: () => bloodTestRepository.mockLoadAllParameters(
      parameters: [
        createBloodTestParameter(id: 'p1'),
        createBloodTestParameter(id: 'p2'),
        createBloodTestParameter(id: 'p3'),
      ],
    ),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        parameters: [
          createBloodTestParameter(id: 'p1'),
          createBloodTestParameter(id: 'p2'),
          createBloodTestParameter(id: 'p3'),
        ],
      )
    ],
    verify: (_) => verify(
      () => bloodTestRepository.loadAllParameters(),
    ).called(1),
  );
}
