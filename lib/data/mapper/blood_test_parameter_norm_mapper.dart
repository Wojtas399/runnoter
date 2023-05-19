import 'package:firebase/model/blood_test_parameter_norm_dto.dart';

import '../../domain/model/blood_test_parameter.dart';

BloodTestParameterNorm mapBloodTestParameterNormFromDto(
  BloodTestParameterNormDto dto,
) =>
    BloodTestParameterNorm(
      min: dto.min,
      max: dto.max,
    );
