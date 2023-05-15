import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/health_measurement_creator/bloc/health_measurement_creator_state.dart';

void main() {
  late HealthMeasurementCreatorState state;

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        status: status,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );

  setUp(() {
    state = createState();
  });

  test(
    'is submit button disabled, '
    'resting heart rate is null, '
    'should be true',
    () {
      state = state.copyWith(
        fastingWeight: 61.5,
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'fasting weight is null, '
    'should be true',
    () {
      state = state.copyWith(
        restingHeartRate: 50,
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'resting heart rate and fasting weight are not null, '
    'should be false',
    () {
      state = state.copyWith(
        restingHeartRate: 50,
        fastingWeight: 61.6,
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
      final DateTime expectedDate = DateTime(2023, 2, 10);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with resting heart rate',
    () {
      const int expectedValue = 50;

      state = state.copyWith(restingHeartRate: expectedValue);
      final state2 = state.copyWith();

      expect(state.restingHeartRate, expectedValue);
      expect(state2.restingHeartRate, expectedValue);
    },
  );

  test(
    'copy with fasting weight',
    () {
      const double expectedValue = 61.5;

      state = state.copyWith(fastingWeight: expectedValue);
      final state2 = state.copyWith();

      expect(state.fastingWeight, expectedValue);
      expect(state2.fastingWeight, expectedValue);
    },
  );
}
