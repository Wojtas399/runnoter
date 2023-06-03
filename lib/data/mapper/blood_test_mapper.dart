import 'package:firebase/firebase.dart';

import '../../domain/entity/blood_test.dart';
import 'blood_parameter_result_mapper.dart';

BloodTest mapBloodTestFromDto(
  BloodTestDto bloodTestDto,
) =>
    BloodTest(
      id: bloodTestDto.id,
      userId: bloodTestDto.userId,
      date: bloodTestDto.date,
      parameterResults: bloodTestDto.parameterResultDtos
          .map(mapBloodParameterResultFromDto)
          .toList(),
    );
