import 'package:firebase/firebase.dart';

BloodTestParameterDto createBloodTestParameterDto({
  String id = '',
  BloodTestParameterType type = BloodTestParameterType.basic,
  String name = '',
  BloodTestParameterUnit unit = BloodTestParameterUnit.femtolitre,
  BloodTestParameterNormDto normDto = const BloodTestParameterNormDto(
    min: 0,
    max: 1,
  ),
}) =>
    BloodTestParameterDto(
      id: id,
      type: type,
      name: name,
      unit: unit,
      norm: normDto,
    );
