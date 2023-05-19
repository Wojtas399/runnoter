import 'package:firebase/firebase.dart' as firebase;

import '../../domain/model/blood_test_parameter.dart';
import 'blood_test_parameter_norm_mapper.dart';
import 'blood_test_parameter_type_mapper.dart';
import 'blood_test_parameter_unit_mapper.dart';

BloodTestParameter mapBloodTestParameterFromDto(
  firebase.BloodTestParameterDto dto,
) =>
    BloodTestParameter(
      id: dto.id,
      type: mapBloodTestParameterTypeFromDto(dto.type),
      name: dto.name,
      unit: mapBloodTestParameterUnitFromDto(dto.unit),
      norm: mapBloodTestParameterNormFromDto(dto.norm),
      description: dto.description,
    );
