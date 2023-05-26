import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_readings.dart';

BloodReadings createBloodReadings({
  String id = '',
  String userId = '',
  DateTime? date,
  List<BloodParameterReading> readings = const [
    BloodParameterReading(
      parameter: BloodParameter.wbc,
      readingValue: 4.45,
    ),
  ],
}) =>
    BloodReadings(
      id: id,
      userId: userId,
      date: date ?? DateTime(2023),
      readings: readings,
    );
