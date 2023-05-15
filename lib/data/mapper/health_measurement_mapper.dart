import 'package:firebase/firebase.dart';

import '../../domain/model/health_measurement.dart';

HealthMeasurementDto mapHealthMeasurementToFirebase(
  HealthMeasurement healthMeasurement,
) =>
    HealthMeasurementDto(
      userId: healthMeasurement.userId,
      date: healthMeasurement.date,
      restingHeartRate: healthMeasurement.restingHeartRate,
      fastingWeight: healthMeasurement.fastingWeight,
    );

HealthMeasurement mapHealthMeasurementFromFirebase(
  HealthMeasurementDto healthMeasurementDto,
) =>
    HealthMeasurement(
      userId: healthMeasurementDto.userId,
      date: healthMeasurementDto.date,
      restingHeartRate: healthMeasurementDto.restingHeartRate,
      fastingWeight: healthMeasurementDto.fastingWeight,
    );
