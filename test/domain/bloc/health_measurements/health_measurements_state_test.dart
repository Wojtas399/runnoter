import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/health_measurements/health_measurements_bloc.dart';
import 'package:runnoter/domain/entity/health_measurement.dart';

import '../../../util/health_measurement_creator.dart';

void main() {
  late HealthMeasurementsState state;

  HealthMeasurementsState createState({
    BlocStatus status = const BlocStatusComplete(),
    List<HealthMeasurement>? measurements,
  }) =>
      HealthMeasurementsState(
        status: status,
        measurements: measurements,
      );

  setUp(
    () => state = createState(),
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
    'copy with measurements',
    () {
      final List<HealthMeasurement> expectedMeasurements = [
        createHealthMeasurement(
          date: DateTime(2023, 2, 10),
        ),
        createHealthMeasurement(
          date: DateTime(2023, 2, 12),
        ),
        createHealthMeasurement(
          date: DateTime(2023, 2, 14),
        ),
      ];

      state = state.copyWith(measurements: expectedMeasurements);
      final state2 = state.copyWith();

      expect(state.measurements, expectedMeasurements);
      expect(state2.measurements, expectedMeasurements);
    },
  );
}
