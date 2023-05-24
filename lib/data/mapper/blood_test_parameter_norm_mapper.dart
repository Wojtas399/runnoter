import 'package:firebase/firebase.dart';

import '../../domain/model/blood_parameter.dart';

BloodParameterNorm mapBloodParameterNormFromDto(
  BloodParameterNormDto dto,
) =>
    BloodParameterNorm(
      min: dto.min,
      max: dto.max,
    );
