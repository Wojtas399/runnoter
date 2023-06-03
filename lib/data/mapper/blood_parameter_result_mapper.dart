import 'package:firebase/model/blood_parameter_result_dto.dart';

import '../../domain/model/blood_parameter.dart';
import 'blood_parameter_mapper.dart';

BloodParameterResult mapBloodParameterResultFromDto(
  BloodParameterResultDto bloodParameterResultDto,
) =>
    BloodParameterResult(
      parameter: mapBloodParameterFromDtoType(
        bloodParameterResultDto.parameter,
      ),
      value: bloodParameterResultDto.value,
    );

BloodParameterResultDto mapBloodParameterResultToDto(
  BloodParameterResult bloodParameterResultDto,
) =>
    BloodParameterResultDto(
      parameter: mapBloodParameterToDtoType(bloodParameterResultDto.parameter),
      value: bloodParameterResultDto.value,
    );
