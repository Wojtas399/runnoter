import 'package:runnoter/domain/model/blood_readings.dart';

BloodReadings createBloodReadings({
  String id = '',
  String userId = '',
  DateTime? date,
  List<BloodParameterReading> readings = const [],
}) =>
    BloodReadings(
      id: id,
      userId: userId,
      date: date ?? DateTime(2023),
      readings: readings,
    );
