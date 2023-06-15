import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

import '../../../creators/health_measurement_creator.dart';

void main() {
  late HealthMeasurementCreatorState state;

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    HealthMeasurement? measurement,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        status: status,
        measurement: measurement,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );

  setUp(() {
    state = createState();
  });

  test(
    'can submit, '
    'resting heart rate is null, '
    'should be false',
    () {
      state = createState(
        fastingWeight: 61.5,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'resting heart rate is 0, '
    'should be false',
    () {
      state = createState(
        restingHeartRate: 0,
        fastingWeight: 61.5,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'fasting weight is null, '
    'should be false',
    () {
      state = createState(
        restingHeartRate: 50,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'fasting weight is 0, '
    'should be false',
    () {
      state = createState(
        restingHeartRate: 50,
        fastingWeight: 0,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'resting heart rate and fasting weight are same as original, '
    'should be false',
    () {
      state = createState(
        measurement: createHealthMeasurement(
          restingHeartRate: 51,
          fastingWeight: 61.5,
        ),
        restingHeartRate: 51,
        fastingWeight: 61.5,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'resting heart rate and fasting weight are not null and higher than 0, '
    'should be true',
    () {
      state = createState(
        restingHeartRate: 51,
        fastingWeight: 61.5,
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
    'copy with measurement',
    () {
      final HealthMeasurement expectedMeasurement = createHealthMeasurement(
        userId: 'u1',
        date: DateTime(2023, 2, 10),
      );

      state = state.copyWith(measurement: expectedMeasurement);
      final state2 = state.copyWith();

      expect(state.measurement, expectedMeasurement);
      expect(state2.measurement, expectedMeasurement);
    },
  );

  test(
    'copy with resting heart rate',
    () {
      const int expectedRestingHeartRate = 50;

      state = state.copyWith(restingHeartRate: expectedRestingHeartRate);
      final state2 = state.copyWith();

      expect(state.restingHeartRate, expectedRestingHeartRate);
      expect(state2.restingHeartRate, expectedRestingHeartRate);
    },
  );

  test(
    'copy with fasting weight',
    () {
      const double expectedFastingWeight = 61.5;

      state = state.copyWith(fastingWeight: expectedFastingWeight);
      final state2 = state.copyWith();

      expect(state.fastingWeight, expectedFastingWeight);
      expect(state2.fastingWeight, expectedFastingWeight);
    },
  );
}
