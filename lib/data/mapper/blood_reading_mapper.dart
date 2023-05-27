import 'package:firebase/firebase.dart';

import '../../domain/model/blood_reading.dart';
import 'blood_reading_parameter_mapper.dart';

BloodReading mapBloodReadingFromDto(
  BloodReadingDto bloodReadingDto,
) =>
    BloodReading(
      id: bloodReadingDto.id,
      userId: bloodReadingDto.userId,
      date: bloodReadingDto.date,
      parameters: bloodReadingDto.parameterDtos
          .map(mapBloodReadingParameterFromDto)
          .toList(),
    );
