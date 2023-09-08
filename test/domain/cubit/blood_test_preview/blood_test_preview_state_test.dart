import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/blood_parameter.dart';
import 'package:runnoter/domain/cubit/blood_test_preview/blood_test_preview_cubit.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  late BloodTestPreviewState state;

  setUp(
    () => state = const BloodTestPreviewState(),
  );

  test(
    'copy with date, '
    'should copy current value if new value is null',
    () {
      final DateTime expected = DateTime(2023, 5, 1);

      state = state.copyWith(date: expected);
      final state2 = state.copyWith();

      expect(state.date, expected);
      expect(state2.date, expected);
    },
  );

  test(
    'copy with gender, '
    'should copy current value if new value is null',
    () {
      const Gender expected = Gender.female;

      state = state.copyWith(gender: expected);
      final state2 = state.copyWith();

      expect(state.gender, expected);
      expect(state2.gender, expected);
    },
  );

  test(
    'copy with parameter results, '
    'should copy current value if new value is null',
    () {
      const List<BloodParameterResult> expected = [
        BloodParameterResult(
          parameter: BloodParameter.wbc,
          value: 4.45,
        ),
        BloodParameterResult(
          parameter: BloodParameter.cpk,
          value: 210,
        ),
      ];

      state = state.copyWith(parameterResults: expected);
      final state2 = state.copyWith();

      expect(state.parameterResults, expected);
      expect(state2.parameterResults, expected);
    },
  );
}
