import 'package:runnoter/domain/model/health_measurement.dart';

HealthMeasurement createHealthMeasurement({
  DateTime? date,
  int restingHeartRate = 50,
  double fastingWeight = 50.0,
}) =>
    HealthMeasurement(
      date: date ?? DateTime(2023),
      restingHeartRate: restingHeartRate,
      fastingWeight: fastingWeight,
    );
