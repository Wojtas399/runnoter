import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/blood_test.dart';
import 'package:runnoter/data/model/custom_exception.dart';
import 'package:runnoter/data/model/user.dart';
import 'package:runnoter/data/repository/blood_test/blood_test_repository.dart';
import 'package:runnoter/data/repository/user/user_repository.dart';
import 'package:runnoter/ui/cubit/blood_test_creator/blood_test_creator_cubit.dart';
import 'package:runnoter/ui/model/cubit_status.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/data/repository/mock_blood_test_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();
  final bloodTestRepository = MockBloodTestRepository();
  const String userId = 'u1';
  const String bloodTestId = 'b1';

  BloodTestCreatorCubit createCubit({
    String? bloodTestId,
    Gender? gender,
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorCubit(
        userId: userId,
        bloodTestId: bloodTestId,
        initialState: BloodTestCreatorState(
          status: const CubitStatusInitial(),
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
    "should load user's gender and blood test and "
    'should update all params in state',
    build: () => createCubit(bloodTestId: bloodTestId),
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
    act: (cubit) => cubit.initialize(),
    expect: () => [
      BloodTestCreatorState(
        status: const CubitStatusComplete(),
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
    build: () => createCubit(),
    setUp: () => userRepository.mockGetUserById(
      user: createUser(gender: Gender.male),
    ),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const BloodTestCreatorState(
        status: CubitStatusComplete(),
        gender: Gender.male,
      ),
    ],
    verify: (_) => verify(
      () => userRepository.getUserById(userId: userId),
    ).called(1),
  );

  blocTest(
    'dateChanged, '
    'should update date in state',
    build: () => createCubit(),
    act: (cubit) => cubit.dateChanged(DateTime(2023, 5, 20)),
    expect: () => [
      BloodTestCreatorState(
        status: const CubitStatusComplete(),
        date: DateTime(2023, 5, 20),
      ),
    ],
  );

  blocTest(
    'parameterValueChanged, '
    'parameter exists in state, '
    'should update parameter value',
    build: () => createCubit(
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
    act: (cubit) => cubit.parameterValueChanged(
      parameter: BloodParameter.wbc,
      value: 4.45,
    ),
    expect: () => [
      const BloodTestCreatorState(
        status: CubitStatusComplete(),
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
    'parameterValueChanged, '
    'parameter exists in state and its new value is null, '
    'should remove parameter from list of parameter results',
    build: () => createCubit(
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
    act: (cubit) => cubit.parameterValueChanged(
      parameter: BloodParameter.wbc,
      value: null,
    ),
    expect: () => [
      const BloodTestCreatorState(
        status: CubitStatusComplete(),
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
    'parameterValueChanged, '
    'parameter does not exist in state, '
    'should add parameter to list',
    build: () => createCubit(
      parameterResults: const [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.50,
        ),
      ],
    ),
    act: (cubit) => cubit.parameterValueChanged(
      parameter: BloodParameter.sodium,
      value: 140,
    ),
    expect: () => [
      const BloodTestCreatorState(
        status: CubitStatusComplete(),
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
    build: () => createCubit(),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'blood test is null, '
    'should call method from blood test repository to add new blood test and '
    'should emit complete status with bloodTestAdded info',
    build: () => createCubit(
      gender: Gender.male,
      date: DateTime(2023, 5, 20),
      parameterResults: const [
        BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
        BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
      ],
    ),
    setUp: () => bloodTestRepository.mockAddNewTest(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      BloodTestCreatorState(
        status: const CubitStatusLoading(),
        gender: Gender.male,
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
      BloodTestCreatorState(
        status: const CubitStatusComplete<BloodTestCreatorCubitInfo>(
          info: BloodTestCreatorCubitInfo.bloodTestAdded,
        ),
        gender: Gender.male,
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
    ],
    verify: (_) => verify(
      () => bloodTestRepository.addNewTest(
        userId: userId,
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'blood test is not null, '
    'should call method from blood test repository to update blood test and '
    'should emit complete status with bloodTestUpdated info',
    build: () => createCubit(
      gender: Gender.male,
      bloodTest: createBloodTest(
        id: bloodTestId,
        date: DateTime(2023, 5, 12),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.cpk, value: 300),
        ],
      ),
      date: DateTime(2023, 5, 20),
      parameterResults: const [
        BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
        BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
      ],
    ),
    setUp: () => bloodTestRepository.mockUpdateTest(),
    act: (cubit) => cubit.submit(),
    expect: () => [
      BloodTestCreatorState(
        status: const CubitStatusLoading(),
        gender: Gender.male,
        bloodTest: createBloodTest(
          id: bloodTestId,
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(parameter: BloodParameter.cpk, value: 300),
          ],
        ),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
      BloodTestCreatorState(
        status: const CubitStatusComplete<BloodTestCreatorCubitInfo>(
          info: BloodTestCreatorCubitInfo.bloodTestUpdated,
        ),
        gender: Gender.male,
        bloodTest: createBloodTest(
          id: bloodTestId,
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(parameter: BloodParameter.cpk, value: 300),
          ],
        ),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
    ],
    verify: (_) => verify(
      () => bloodTestRepository.updateTest(
        bloodTestId: bloodTestId,
        userId: userId,
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'blood test is not null, '
    'repository method to update blood test throws entity exception with'
    'entityNotFound code, '
    'should emit error status with bloodTestNoLongerExists info',
    build: () => createCubit(
      gender: Gender.male,
      bloodTest: createBloodTest(
        id: bloodTestId,
        date: DateTime(2023, 5, 12),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.cpk, value: 300),
        ],
      ),
      date: DateTime(2023, 5, 20),
      parameterResults: const [
        BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
        BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
      ],
    ),
    setUp: () => bloodTestRepository.mockUpdateTest(
      throwable: const EntityException(
        code: EntityExceptionCode.entityNotFound,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      BloodTestCreatorState(
        status: const CubitStatusLoading(),
        gender: Gender.male,
        bloodTest: createBloodTest(
          id: bloodTestId,
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(parameter: BloodParameter.cpk, value: 300),
          ],
        ),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
      BloodTestCreatorState(
        status: const CubitStatusError<BloodTestCreatorCubitError>(
          error: BloodTestCreatorCubitError.bloodTestNoLongerExists,
        ),
        gender: Gender.male,
        bloodTest: createBloodTest(
          id: bloodTestId,
          date: DateTime(2023, 5, 12),
          parameterResults: const [
            BloodParameterResult(parameter: BloodParameter.cpk, value: 300),
          ],
        ),
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
    ],
    verify: (_) => verify(
      () => bloodTestRepository.updateTest(
        bloodTestId: bloodTestId,
        userId: userId,
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
          BloodParameterResult(parameter: BloodParameter.sodium, value: 139),
        ],
      ),
    ).called(1),
  );
}
