import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/entity/health_measurement.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/feature/dialog/health_measurement_creator/cubit/health_measurement_creator_cubit.dart';

import '../../../../creators/health_measurement_creator.dart';
import '../../../../mock/common/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  late HealthMeasurementCreatorState state;
  final DateTime todayDate = DateTime(2023, 2, 10);

  setUpAll(() {
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  setUp(() {
    state = HealthMeasurementCreatorState(status: const CubitStatusInitial());
    dateService.mockGetToday(todayDate: todayDate);
    dateService.mockAreDaysTheSame(expected: false);
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
      dateService.mockAreDaysTheSame(expected: true);

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
    'copy with date, '
    'should copy current value if new value is null',
    () {
      final DateTime expected = DateTime(2023, 2, 20);

      state = state.copyWith(date: expected);
      final state2 = state.copyWith();

      expect(state.date, expected);
      expect(state2.date, expected);
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
    'copy with measurement, '
    'should copy current value if new value is null',
    () {
      final HealthMeasurement expected = createHealthMeasurement(
        userId: 'u1',
        date: DateTime(2023, 2, 10),
      );

      state = state.copyWith(measurement: expected);
      final state2 = state.copyWith();

      expect(state.measurement, expected);
      expect(state2.measurement, expected);
    },
  );

  test(
    'copy with restingHeartRate, '
    'should copy current value if new value is null',
    () {
      const int expected = 50;

      state = state.copyWith(restingHeartRate: expected);
      final state2 = state.copyWith();

      expect(state.restingHeartRate, expected);
      expect(state2.restingHeartRate, expected);
    },
  );

  test(
    'copy with fastingWeight, '
    'should copy current value if new value is null',
    () {
      const double expected = 61.5;

      state = state.copyWith(fastingWeight: expected);
      final state2 = state.copyWith();

      expect(state.fastingWeight, expected);
      expect(state2.fastingWeight, expected);
    },
  );
}
