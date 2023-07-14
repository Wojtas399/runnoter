import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';
import 'package:runnoter/domain/entity/blood_test.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final bloodTestRepository = MockBloodTestRepository();
  const String loggedUserId = 'u1';
  const String bloodTestId = 'b1';

  BloodTestCreatorBloc createBloc({
    String? bloodTestId,
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorBloc(
        authService: authService,
        bloodTestRepository: bloodTestRepository,
        bloodTestId: bloodTestId,
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
    'should load blood test from repository and should update all params in state',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      bloodTestRepository.mockGetTestById(
        bloodTest: createBloodTest(
          id: bloodTestId,
          userId: loggedUserId,
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
    act: (bloc) => bloc.add(const BloodTestCreatorEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodTest: createBloodTest(
          id: bloodTestId,
          userId: loggedUserId,
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
          bloodTestId: bloodTestId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const BloodTestCreatorEventInitialize()),
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
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const BloodTestCreatorEventInitialize()),
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
    act: (bloc) => bloc.add(BloodTestCreatorEventDateChanged(
      date: DateTime(2023, 5, 20),
    )),
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
    act: (bloc) => bloc.add(const BloodTestCreatorEventParameterResultChanged(
      parameter: BloodParameter.wbc,
      value: 4.45,
    )),
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
    act: (bloc) => bloc.add(const BloodTestCreatorEventParameterResultChanged(
      parameter: BloodParameter.wbc,
      value: null,
    )),
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
    act: (bloc) => bloc.add(const BloodTestCreatorEventParameterResultChanged(
      parameter: BloodParameter.sodium,
      value: 140,
    )),
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
    act: (bloc) => bloc.add(const BloodTestCreatorEventSubmit()),
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
    act: (bloc) => bloc.add(const BloodTestCreatorEventSubmit()),
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
      authService.mockGetLoggedUserId(userId: loggedUserId);
      bloodTestRepository.mockAddNewTest();
    },
    act: (bloc) => bloc.add(const BloodTestCreatorEventSubmit()),
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
          userId: loggedUserId,
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
        id: bloodTestId,
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
      authService.mockGetLoggedUserId(userId: loggedUserId);
      bloodTestRepository.mockUpdateTest();
    },
    act: (bloc) => bloc.add(const BloodTestCreatorEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        bloodTest: createBloodTest(
          id: bloodTestId,
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
          id: bloodTestId,
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
          bloodTestId: bloodTestId,
          userId: loggedUserId,
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
