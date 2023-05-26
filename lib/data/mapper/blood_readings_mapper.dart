import 'package:firebase/firebase.dart';

import '../../domain/model/blood_readings.dart';
import 'blood_parameter_reading_mapper.dart';

BloodReadings mapBloodReadingsFromDto(
  BloodReadingsDto bloodReadingsDto,
) =>
    BloodReadings(
      id: bloodReadingsDto.id,
      userId: bloodReadingsDto.userId,
      date: bloodReadingsDto.date,
      readings: bloodReadingsDto.readingDtos
          .map(mapBloodParameterReadingFromDto)
          .toList(),
    );
