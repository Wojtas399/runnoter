import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_test_creator/bloc/blood_test_creator_bloc.dart';

import '../../../util/blood_test_creator.dart';

void main() {
  late BloodTestCreatorState state;

  setUp(
    () => state = const BloodTestCreatorState(
      status: BlocStatusInitial(),
    ),
  );

  test(
    'are date valid, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        date: null,
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
        ],
      );

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
    'parameter results are null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 12),
        parameterResults: null,
      );

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
    'list of parameter results is empty, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 20),
        parameterResults: const [],
      );

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
    'date and parameter results are valid, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 20),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
        ],
      );

      expect(state.areDataValid, true);
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
