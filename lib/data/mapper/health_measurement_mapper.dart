import 'package:firebase/firebase.dart';

import '../../domain/entity/health_measurement.dart';

HealthMeasurementDto mapHealthMeasurementToDto(
  HealthMeasurement healthMeasurement,
) =>
    HealthMeasurementDto(
      userId: healthMeasurement.userId,
      date: healthMeasurement.date,
      restingHeartRate: healthMeasurement.restingHeartRate,
      fastingWeight: healthMeasurement.fastingWeight,
    );

HealthMeasurement mapHealthMeasurementFromDto(
  HealthMeasurementDto healthMeasurementDto,
) =>
    HealthMeasurement(
      userId: healthMeasurementDto.userId,
      date: healthMeasurementDto.date,
      restingHeartRate: healthMeasurementDto.restingHeartRate,
      fastingWeight: healthMeasurementDto.fastingWeight,
    );
