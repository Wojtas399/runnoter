import 'package:runnoter/domain/model/morning_measurement.dart';

MorningMeasurement createMorningMeasurement({
  DateTime? date,
  int restingHeartRate = 50,
  double fastingWeight = 50.0,
}) =>
    MorningMeasurement(
      date: date ?? DateTime(2023),
      restingHeartRate: restingHeartRate,
      fastingWeight: fastingWeight,
    );
