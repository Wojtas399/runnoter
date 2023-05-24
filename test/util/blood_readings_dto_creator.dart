import 'package:firebase/firebase.dart';

BloodReadingsDto createBloodReadingsDto({
  String id = '',
  String userId = '',
  DateTime? date,
  List<BloodParameterReadingDto> readingDtos = const [
    BloodParameterReadingDto(
      parameter: BloodParameter.wbc,
      readingValue: 4.45,
    ),
  ],
}) =>
    BloodReadingsDto(
      id: id,
      userId: userId,
      date: date ?? DateTime(2023),
      readingDtos: readingDtos,
    );
