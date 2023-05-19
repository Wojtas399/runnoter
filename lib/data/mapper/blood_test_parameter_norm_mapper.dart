import 'package:firebase/firebase.dart';

import '../../domain/model/blood_test_parameter.dart';

BloodTestParameterNorm mapBloodTestParameterNormFromDto(
  BloodTestParameterNormDto dto,
) =>
    BloodTestParameterNorm(
      min: dto.min,
      max: dto.max,
    );
