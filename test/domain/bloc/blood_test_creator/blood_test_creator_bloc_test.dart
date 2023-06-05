import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';
import 'package:runnoter/domain/entity/blood_test.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_blood_test_repository.dart';
import '../../../creators/blood_test_creator.dart';

void main() {
  final authService = MockAuthService();
  final bloodTestRepository = MockBloodTestRepository();

  BloodTestCreatorBloc createBloc({
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorBloc(
        authService: authService,
        bloodTestRepository: bloodTestRepository,
        state: BloodTestCreatorState(
          status: const BlocStatusInitial(),
          bloodTest: bloodTest,
          date: date,
          parameterResults: parameterResults,
        ),
      );

  BloodTestCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorState(
        status: status,
        bloodTest: bloodTest,
        date: date,
        parameterResults: parameterResults,
      );

  tearDown(() {
    reset(authService);
    reset(bloodTestRepository);
  });

  blocTest(
    'initialize, '
    'blood test id is not null, '
    'should load blood test from repository and should update all params in state',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodTestRepository.mockGetTestById(
        bloodTest: createBloodTest(
          id: 'bt1',
          userId: 'u1',
          date: DateTime(2023, 5, 10),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.wbc,
              value: 4.45,
            ),
          ],
        ),
      );
    },
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventInitialize(
        bloodTestId: 'bt1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodTest: createBloodTest(
          id: 'bt1',
          userId: 'u1',
          date: DateTime(2023, 5, 10),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.wbc,
              value: 4.45,
            ),
          ],
        ),
        date: DateTime(2023, 5, 10),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodTestRepository.getTestById(
          bloodTestId: 'bt1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'blood test id is not null, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventInitialize(
        bloodTestId: 'bt1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'blood test id is null, '
    'should set list of parameter results as empty in state',
    build: () => createBloc(),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventInitialize(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        parameterResults: [],
      ),
    ],
  );

  blocTest(
    'date changed, '
    'should update date in state',
    build: () => createBloc(),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      BloodTestCreatorEventDateChanged(
        date: DateTime(2023, 5, 20),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 5, 20),
      ),
    ],
  );

  blocTest(
    'parameter result changed, '
    'parameter exists in state, '
    'should update parameter value',
    build: () => createBloc(
      parameterResults: const [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.50,
        ),
        BloodParameterResult(
          parameter: BloodParameter.sodium,
          value: 140,
        ),
      ],
    ),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventParameterResultChanged(
        parameter: BloodParameter.wbc,
        value: 4.45,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
          BloodParameterResult(
            parameter: BloodParameter.sodium,
            value: 140,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'parameter result changed, '
    'parameter exists in state and its new value is null, '
    'should remove parameter from list of parameter results',
    build: () => createBloc(
      parameterResults: const [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.50,
        ),
        BloodParameterResult(
          parameter: BloodParameter.sodium,
          value: 140,
        ),
      ],
    ),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventParameterResultChanged(
        parameter: BloodParameter.wbc,
        value: null,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.sodium,
            value: 140,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'parameter result changed, '
    'parameter does not exist in state, '
    'should add parameter to list',
    build: () => createBloc(
      parameterResults: const [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.50,
        ),
      ],
    ),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventParameterResultChanged(
        parameter: BloodParameter.sodium,
        value: 140,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.50,
          ),
          BloodParameterResult(
            parameter: BloodParameter.sodium,
            value: 140,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'submit, '
    'data are invalid, '
    'should finish event call',
    build: () => createBloc(),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(
      date: DateTime(2023, 5, 20),
      parameterResults: const [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
      ],
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
        ],
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'blood test in state is null, '
    'should call method from blood test repository to add new blood test and should emit info that new test has been added',
    build: () => createBloc(
      date: DateTime(2023, 5, 20),
      parameterResults: const [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
        BloodParameterResult(
          parameter: BloodParameter.sodium,
          value: 139,
        ),
      ],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodTestRepository.mockAddNewTest();
    },
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
          BloodParameterResult(
            parameter: BloodParameter.sodium,
            value: 139,
          ),
        ],
      ),
      createState(
        status: const BlocStatusComplete<BloodTestCreatorBlocInfo>(
          info: BloodTestCreatorBlocInfo.bloodTestAdded,
        ),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
          BloodParameterResult(
            parameter: BloodParameter.sodium,
            value: 139,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodTestRepository.addNewTest(
          userId: 'u1',
          date: DateTime(2023, 5, 20),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.wbc,
              value: 4.45,
            ),
            BloodParameterResult(
              parameter: BloodParameter.sodium,
              value: 139,
            ),
          ],
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'blood test in state is not null, '
    'should call method from blood test repository to update blood test and should emit info that new test has been updated',
    build: () => createBloc(
      bloodTest: createBloodTest(
        id: 'bt1',
        date: DateTime(2023, 5, 12),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.cpk,
            value: 300,
          ),
        ],
      ),
      date: DateTime(2023, 5, 20),
      parameterResults: const [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
        BloodParameterResult(
          parameter: BloodParameter.sodium,
          value: 139,
        ),
      ],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodTestRepository.mockUpdateTest();
    },
    act: (BloodTestCreatorBloc bloc) => bloc.add(
      const BloodTestCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        bloodTest: createBloodTest(
          id: 'bt1',
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.cpk,
              value: 300,
            ),
          ],
        ),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
          BloodParameterResult(
            parameter: BloodParameter.sodium,
            value: 139,
          ),
        ],
      ),
      createState(
        status: const BlocStatusComplete<BloodTestCreatorBlocInfo>(
          info: BloodTestCreatorBlocInfo.bloodTestUpdated,
        ),
        bloodTest: createBloodTest(
          id: 'bt1',
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.cpk,
              value: 300,
            ),
          ],
        ),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
          BloodParameterResult(
            parameter: BloodParameter.sodium,
            value: 139,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodTestRepository.updateTest(
          bloodTestId: 'bt1',
          userId: 'u1',
          date: DateTime(2023, 5, 20),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.wbc,
              value: 4.45,
            ),
            BloodParameterResult(
              parameter: BloodParameter.sodium,
              value: 139,
            ),
          ],
        ),
      ).called(1);
    },
  );
}
