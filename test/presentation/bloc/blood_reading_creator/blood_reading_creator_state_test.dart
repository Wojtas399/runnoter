import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_readings_creator/bloc/blood_reading_creator_state.dart';

void main() {
  late BloodReadingCreatorState state;

  setUp(
    () => state = const BloodReadingCreatorState(
      status: BlocStatusInitial(),
    ),
  );

  test(
    'is submit button disabled, '
    'date is null, '
    'should be true',
    () {
      state = state.copyWith(
        date: null,
        parameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'parameters are null, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 12),
        parameters: null,
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'list of parameters is empty, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 20),
        parameters: const [],
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'date and parameters are valid, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 20),
        parameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
        ],
      );

      expect(state.isSubmitButtonDisabled, false);
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
    'copy with parameters',
    () {
      const List<BloodReadingParameter> expectedParameters = [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.45,
        ),
      ];

      state = state.copyWith(parameters: expectedParameters);
      final state2 = state.copyWith();

      expect(state.parameters, expectedParameters);
      expect(state2.parameters, expectedParameters);
    },
  );
}
