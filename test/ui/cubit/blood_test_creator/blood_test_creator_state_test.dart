import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/blood_parameter.dart';
import 'package:runnoter/data/entity/blood_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/cubit/blood_test_creator/blood_test_creator_cubit.dart';

import '../../../creators/blood_test_creator.dart';

void main() {
  late BloodTestCreatorState state;
  final BloodTest bloodTest = createBloodTest(
    date: DateTime(2023, 5, 20),
    parameterResults: const [
      BloodParameterResult(parameter: BloodParameter.wbc, value: 4.45),
      BloodParameterResult(parameter: BloodParameter.cpk, value: 300),
    ],
  );

  setUp(
    () => state = const BloodTestCreatorState(
      status: CubitStatusInitial(),
    ),
  );

  test(
    'can submit, '
    'gender is null, '
    'should be false',
    () {
      state = state.copyWith(
        bloodTest: bloodTest,
        date: bloodTest.date,
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
        ],
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        bloodTest: bloodTest,
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
        ],
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date is same as original, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        bloodTest: bloodTest,
        date: bloodTest.date,
        parameterResults: bloodTest.parameterResults,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'parameter results are null, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        bloodTest: bloodTest,
        date: DateTime(2023, 5, 12),
        parameterResults: null,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'list of parameter results is empty, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        bloodTest: bloodTest,
        date: DateTime(2023, 5, 20),
        parameterResults: const [],
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'parameter results are same as original, '
    'should be false',
    () {
      state = state.copyWith(
        gender: Gender.male,
        bloodTest: bloodTest,
        date: DateTime(2023, 5, 20),
        parameterResults: bloodTest.parameterResults,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date and parameter results are valid and date is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        gender: Gender.male,
        bloodTest: bloodTest,
        date: DateTime(2023, 5, 12),
        parameterResults: bloodTest.parameterResults,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'date and parameter results are valid and parameterResults are different than original, '
    'should be true',
    () {
      state = state.copyWith(
        gender: Gender.male,
        bloodTest: bloodTest,
        date: bloodTest.date,
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.40,
          ),
          BloodParameterResult(
            parameter: BloodParameter.cpk,
            value: 300,
          ),
        ],
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'copy with status, '
    'should set complete status if new status is null',
    () {
      const CubitStatus expected = CubitStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with gender, '
    'should copy current value if new value is null',
    () {
      const Gender expected = Gender.male;

      state = state.copyWith(gender: expected);
      final state2 = state.copyWith();

      expect(state.gender, expected);
      expect(state2.gender, expected);
    },
  );

  test(
    'copy with bloodTest, '
    'should copy current value if new value is null',
    () {
      final BloodTest expected = createBloodTest(
        id: 'bt1',
        userId: 'u1',
      );

      state = state.copyWith(bloodTest: expected);
      final state2 = state.copyWith();

      expect(state.bloodTest, expected);
      expect(state2.bloodTest, expected);
    },
  );

  test(
    'copy with date, '
    'should copy current value if new value is null',
    () {
      final DateTime expected = DateTime(2023, 5, 20);

      state = state.copyWith(date: expected);
      final state2 = state.copyWith();

      expect(state.date, expected);
      expect(state2.date, expected);
    },
  );

  test(
    'copy with parameterResults, '
    'should copy current value if new value is null',
    () {
      const List<BloodParameterResult> expected = [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
      ];

      state = state.copyWith(parameterResults: expected);
      final state2 = state.copyWith();

      expect(state.parameterResults, expected);
      expect(state2.parameterResults, expected);
    },
  );
}
