import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  late BloodTestPreviewState state;

  setUp(
    () => state = const BloodTestPreviewState(
      status: BlocStatusInitial(),
    ),
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
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 5, 1);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with gender',
    () {
      const Gender expectedGender = Gender.female;

      state = state.copyWith(gender: expectedGender);
      final state2 = state.copyWith();

      expect(state.gender, expectedGender);
      expect(state2.gender, expectedGender);
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
        BloodParameterResult(
          parameter: BloodParameter.cpk,
          value: 210,
        ),
      ];

      state = state.copyWith(parameterResults: expectedParameterResults);
      final state2 = state.copyWith();

      expect(state.parameterResults, expectedParameterResults);
      expect(state2.parameterResults, expectedParameterResults);
    },
  );
}
