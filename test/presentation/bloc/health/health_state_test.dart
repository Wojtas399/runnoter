import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';
import 'package:runnoter/presentation/screen/health/bloc/health_state.dart';

void main() {
  late HealthState state;

  HealthState createState() => const HealthState(
        todayMorningMeasurement: null,
        chartRange: ChartRange.month,
        morningMeasurements: null,
      );

  setUp(() {
    state = createState();
  });

  test(
    'copy with today morning measurement',
    () {
      final MorningMeasurement expectedMorningMeasurement = MorningMeasurement(
        date: DateTime(2023, 1, 10),
        restingHeartRate: 50,
        weight: 80.2,
      );

      state = state.copyWith(
        todayMorningMeasurement: expectedMorningMeasurement,
      );
      final state2 = state.copyWith();

      expect(state.todayMorningMeasurement, expectedMorningMeasurement);
      expect(state2.todayMorningMeasurement, expectedMorningMeasurement);
    },
  );

  test(
    'copy with chart range',
    () {
      const ChartRange expectedChartRange = ChartRange.month;

      state = state.copyWith(chartRange: expectedChartRange);
      final state2 = state.copyWith();

      expect(state.chartRange, expectedChartRange);
      expect(state2.chartRange, expectedChartRange);
    },
  );

  test(
    'copy with morning measurements',
    () {
      final List<MorningMeasurement> expectedMorningMeasurements = [
        MorningMeasurement(
          date: DateTime(2023, 1, 10),
          restingHeartRate: 50,
          weight: 80.2,
        ),
        MorningMeasurement(
          date: DateTime(2023, 1, 11),
          restingHeartRate: 49,
          weight: 80.5,
        ),
      ];

      state = state.copyWith(
        morningMeasurements: expectedMorningMeasurements,
      );
      final state2 = state.copyWith();

      expect(state.morningMeasurements, expectedMorningMeasurements);
      expect(state2.morningMeasurements, expectedMorningMeasurements);
    },
  );
}
