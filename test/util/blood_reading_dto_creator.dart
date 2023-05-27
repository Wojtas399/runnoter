import 'package:firebase/firebase.dart';

BloodReadingDto createBloodReadingDto({
  String id = '',
  String userId = '',
  DateTime? date,
  List<BloodReadingParameterDto> parameterDtos = const [
    BloodReadingParameterDto(
      parameter: BloodParameter.wbc,
      readingValue: 4.45,
    ),
  ],
}) =>
    BloodReadingDto(
      id: id,
      userId: userId,
      date: date ?? DateTime(2023),
      parameterDtos: parameterDtos,
    );
