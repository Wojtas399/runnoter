import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/morning_measurement.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/health/bloc/health_bloc.dart';

void main() {
  late HealthState state;

  HealthState createState() => const HealthState(
        status: BlocStatusInitial(),
        thisMorningMeasurement: null,
        chartRange: ChartRange.month,
        morningMeasurements: null,
      );

  setUp(() {
    state = createState();
  });

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
    'copy with this morning measurement',
    () {
      final MorningMeasurement expectedMorningMeasurement = MorningMeasurement(
        date: DateTime(2023, 1, 10),
        restingHeartRate: 50,
        fastingWeight: 80.2,
      );

      state = state.copyWith(
        thisMorningMeasurement: expectedMorningMeasurement,
      );
      final state2 = state.copyWith();

      expect(state.thisMorningMeasurement, expectedMorningMeasurement);
      expect(state2.thisMorningMeasurement, expectedMorningMeasurement);
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
          fastingWeight: 80.2,
        ),
        MorningMeasurement(
          date: DateTime(2023, 1, 11),
          restingHeartRate: 49,
          fastingWeight: 80.5,
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
