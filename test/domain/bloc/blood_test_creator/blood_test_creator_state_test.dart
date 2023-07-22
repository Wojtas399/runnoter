import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';
import 'package:runnoter/domain/entity/blood_test.dart';
import 'package:runnoter/domain/entity/user.dart';

import '../../../creators/blood_test_creator.dart';

void main() {
  late BloodTestCreatorState state;
  final BloodTest bloodTest = createBloodTest(
    date: DateTime(2023, 5, 20),
    parameterResults: const [
      BloodParameterResult(
        parameter: BloodParameter.wbc,
        value: 4.45,
      ),
      BloodParameterResult(
        parameter: BloodParameter.cpk,
        value: 300,
      ),
    ],
  );

  BloodTestCreatorState createState({
    Gender? gender,
    BloodTest? bloodTest,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorState(
        status: const BlocStatusInitial(),
        gender: gender,
        bloodTest: bloodTest,
        date: date,
        parameterResults: parameterResults,
      );

  setUp(
    () => state = const BloodTestCreatorState(
      status: BlocStatusInitial(),
    ),
  );

  test(
    'can submit, '
    'gender is null, '
    'should be false',
    () {
      state = createState(
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
      state = createState(
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
      state = createState(
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
      state = createState(
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
      state = createState(
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
      state = createState(
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
      state = createState(
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
      state = createState(
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
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with gender',
    () {
      const Gender expectedGender = Gender.male;

      state = state.copyWith(gender: expectedGender);
      final state2 = state.copyWith();

      expect(state.gender, expectedGender);
      expect(state2.gender, expectedGender);
    },
  );

  test(
    'copy with blood test',
    () {
      final BloodTest expectedBloodTest = createBloodTest(
        id: 'bt1',
        userId: 'u1',
      );

      state = state.copyWith(bloodTest: expectedBloodTest);
      final state2 = state.copyWith();

      expect(state.bloodTest, expectedBloodTest);
      expect(state2.bloodTest, expectedBloodTest);
    },
  );

  test(
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 5, 20);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with parameter results',
    () {
      const List<BloodParameterResult> expectedParameterResults = [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
      ];

      state = state.copyWith(parameterResults: expectedParameterResults);
      final state2 = state.copyWith();

      expect(state.parameterResults, expectedParameterResults);
      expect(state2.parameterResults, expectedParameterResults);
    },
  );
}
