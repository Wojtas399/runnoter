import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

import '../../../creators/health_measurement_creator.dart';
import '../../../mock/common/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  late HealthMeasurementCreatorState state;
  final DateTime todayDate = DateTime(2023, 2, 10);

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    HealthMeasurement? measurement,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        dateService: dateService,
        status: status,
        measurement: measurement,
        restingHeartRate: restingHeartRate,
        fastingWeight: fastingWeight,
      );

  setUp(() {
    state = createState();
    dateService.mockGetToday(todayDate: todayDate);
    dateService.mockAreDatesTheSame(expected: false);
  });

  tearDown(() {
    reset(dateService);
  });

  test(
    'can submit, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        fastingWeight: 61.5,
        restingHeartRate: 48,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date is from the future, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 3, 1),
        fastingWeight: 61.5,
        restingHeartRate: 48,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'resting heart rate is null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 8),
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
      state = state.copyWith(
        date: DateTime(2023, 2, 8),
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
      state = state.copyWith(
        date: DateTime(2023, 2, 8),
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
      state = state.copyWith(
        date: DateTime(2023, 2, 8),
        restingHeartRate: 50,
        fastingWeight: 0,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date, resting heart rate and fasting weight are same as original, '
    'should be false',
    () {
      state = state.copyWith(
        measurement: createHealthMeasurement(
          date: DateTime(2023, 2, 8),
          restingHeartRate: 51,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 2, 8),
        restingHeartRate: 51,
        fastingWeight: 61.5,
      );

      expect(state.canSubmit, false);
    },
  );

  test(
    'can submit, '
    'date is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        measurement: createHealthMeasurement(
          date: DateTime(2023, 2, 8),
          restingHeartRate: 51,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 2, 7),
        restingHeartRate: 51,
        fastingWeight: 61.5,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'resting heart rate is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        measurement: createHealthMeasurement(
          date: DateTime(2023, 2, 8),
          restingHeartRate: 51,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 2, 8),
        restingHeartRate: 49,
        fastingWeight: 61.5,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'fasting weight is different than original, '
    'should be true',
    () {
      state = state.copyWith(
        measurement: createHealthMeasurement(
          date: DateTime(2023, 2, 8),
          restingHeartRate: 51,
          fastingWeight: 61.5,
        ),
        date: DateTime(2023, 2, 8),
        restingHeartRate: 51,
        fastingWeight: 60.5,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'can submit, '
    'measurement is null and all data are valid, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 2, 8),
        restingHeartRate: 51,
        fastingWeight: 61.5,
      );

      expect(state.canSubmit, true);
    },
  );

  test(
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 2, 20);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
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
