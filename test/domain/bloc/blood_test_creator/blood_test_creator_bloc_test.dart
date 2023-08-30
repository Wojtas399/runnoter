import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/blood_parameter.dart';
import 'package:runnoter/domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import 'package:runnoter/domain/entity/blood_test.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/blood_test_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();
  final bloodTestRepository = MockBloodTestRepository();
  const String userId = 'u1';
  const String bloodTestId = 'b1';

  BloodTestCreatorBloc createBloc({
    String? bloodTestId,
    Gender? gender,
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorBloc(
        userId: userId,
        bloodTestId: bloodTestId,
        state: BloodTestCreatorState(
          status: const BlocStatusInitial(),
          gender: gender,
          bloodTest: bloodTest,
          date: date,
          parameterResults: parameterResults,
        ),
      );

  setUpAll(() {
    GetIt.I.registerFactory<UserRepository>(() => userRepository);
    GetIt.I.registerSingleton<BloodTestRepository>(bloodTestRepository);
  });

  tearDown(() {
    reset(userRepository);
    reset(bloodTestRepository);
  });

  blocTest(
    'initialize, '
    "should load user's gender and blood test and should update all params in state",
    build: () => createBloc(bloodTestId: bloodTestId),
    setUp: () {
      userRepository.mockGetUserById(user: createUser(gender: Gender.male));
      bloodTestRepository.mockGetTestById(
        bloodTest: createBloodTest(
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
      BloodTestCreatorState(
        status: const BlocStatusComplete(),
        gender: Gender.male,
        bloodTest: createBloodTest(
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
      verify(() => userRepository.getUserById(userId: userId)).called(1);
      verify(
        () => bloodTestRepository.getTestById(
          bloodTestId: bloodTestId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'blood test id is null, '
    "should only load user's gender",
    build: () => createBloc(),
    setUp: () => userRepository.mockGetUserById(
      user: createUser(gender: Gender.male),
    ),
    act: (bloc) => bloc.add(const BloodTestCreatorEventInitialize()),
    expect: () => [
      const BloodTestCreatorState(
        status: BlocStatusComplete(),
        gender: Gender.male,
      ),
    ],
    verify: (_) => verify(
      () => userRepository.getUserById(userId: userId),
    ).called(1),
  );

  blocTest(
    'date changed, '
    'should update date in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(BloodTestCreatorEventDateChanged(
      date: DateTime(2023, 5, 20),
    )),
    expect: () => [
      BloodTestCreatorState(
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
      const BloodTestCreatorState(
        status: BlocStatusComplete(),
        parameterResults: [
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
      const BloodTestCreatorState(
        status: BlocStatusComplete(),
        parameterResults: [
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
      const BloodTestCreatorState(
        status: BlocStatusComplete(),
        parameterResults: [
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
    'blood test in state is null, '
    'should call method from blood test repository to add new blood test and '
    'should emit info that new test has been added',
    build: () => createBloc(
      gender: Gender.male,
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
    setUp: () => bloodTestRepository.mockAddNewTest(),
    act: (bloc) => bloc.add(const BloodTestCreatorEventSubmit()),
    expect: () => [
      BloodTestCreatorState(
        status: const BlocStatusLoading(),
        gender: Gender.male,
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
      BloodTestCreatorState(
        status: const BlocStatusComplete<BloodTestCreatorBlocInfo>(
          info: BloodTestCreatorBlocInfo.bloodTestAdded,
        ),
        gender: Gender.male,
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
    verify: (_) => verify(
      () => bloodTestRepository.addNewTest(
        userId: userId,
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
    ).called(1),
  );

  blocTest(
    'submit, '
    'blood test in state is not null, '
    'should call method from blood test repository to update blood test and '
    'should emit info that new test has been updated',
    build: () => createBloc(
      gender: Gender.male,
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
    setUp: () => bloodTestRepository.mockUpdateTest(),
    act: (bloc) => bloc.add(const BloodTestCreatorEventSubmit()),
    expect: () => [
      BloodTestCreatorState(
        status: const BlocStatusLoading(),
        gender: Gender.male,
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
      BloodTestCreatorState(
        status: const BlocStatusComplete<BloodTestCreatorBlocInfo>(
          info: BloodTestCreatorBlocInfo.bloodTestUpdated,
        ),
        gender: Gender.male,
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
    verify: (_) => verify(
      () => bloodTestRepository.updateTest(
        bloodTestId: bloodTestId,
        userId: userId,
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
    ).called(1),
  );
}
