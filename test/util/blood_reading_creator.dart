import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';

BloodReading createBloodReading({
  String id = '',
  String userId = '',
  DateTime? date,
  List<BloodReadingParameter> parameters = const [
    BloodReadingParameter(
      parameter: BloodParameter.wbc,
      readingValue: 4.45,
    ),
  ],
}) =>
    BloodReading(
      id: id,
      userId: userId,
      date: date ?? DateTime(2023),
      parameters: parameters,
    );
