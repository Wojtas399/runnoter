import 'package:firebase/model/blood_reading_parameter_dto.dart';

import '../../domain/model/blood_reading.dart';
import 'blood_parameter_mapper.dart';

BloodReadingParameter mapBloodReadingParameterFromDto(
  BloodReadingParameterDto bloodReadingParameterDto,
) =>
    BloodReadingParameter(
      parameter: mapBloodParameterFromDtoType(
        bloodReadingParameterDto.parameter,
      ),
      readingValue: bloodReadingParameterDto.readingValue,
    );

BloodReadingParameterDto mapBloodReadingParameterToDto(
  BloodReadingParameter bloodReadingParameter,
) =>
    BloodReadingParameterDto(
      parameter: mapBloodParameterToDtoType(bloodReadingParameter.parameter),
      readingValue: bloodReadingParameter.readingValue,
    );
