import 'package:runnoter/data/entity/health_measurement.dart';

HealthMeasurement createHealthMeasurement({
  String userId = '',
  DateTime? date,
  int restingHeartRate = 50,
  double fastingWeight = 50.0,
}) =>
    HealthMeasurement(
      userId: userId,
      date: date ?? DateTime(2023),
      restingHeartRate: restingHeartRate,
      fastingWeight: fastingWeight,
    );
