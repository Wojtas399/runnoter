import 'package:firebase/firebase.dart';

import '../../domain/model/health_measurement.dart';

HealthMeasurementDto mapHealthMeasurementToFirebase(
  HealthMeasurement healthMeasurement,
) =>
    HealthMeasurementDto(
      date: healthMeasurement.date,
      restingHeartRate: healthMeasurement.restingHeartRate,
      fastingWeight: healthMeasurement.fastingWeight,
    );

HealthMeasurement mapHealthMeasurementFromFirebase(
  HealthMeasurementDto healthMeasurementDto,
) =>
    HealthMeasurement(
      date: healthMeasurementDto.date,
      restingHeartRate: healthMeasurementDto.restingHeartRate,
      fastingWeight: healthMeasurementDto.fastingWeight,
    );
