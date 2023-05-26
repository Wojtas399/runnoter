import 'package:firebase/model/blood_parameter_reading_dto.dart';

import '../../domain/model/blood_readings.dart';
import 'blood_parameter_mapper.dart';

BloodParameterReading mapBloodParameterReadingFromDto(
  BloodParameterReadingDto bloodParameterReadingDto,
) =>
    BloodParameterReading(
      parameter: mapBloodParameterFromDtoType(
        bloodParameterReadingDto.parameter,
      ),
      readingValue: bloodParameterReadingDto.readingValue,
    );

BloodParameterReadingDto mapBloodParameterReadingToDto(
  BloodParameterReading bloodParameterReading,
) =>
    BloodParameterReadingDto(
      parameter: mapBloodParameterToDtoType(bloodParameterReading.parameter),
      readingValue: bloodParameterReading.readingValue,
    );
