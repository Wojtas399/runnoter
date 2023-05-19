import 'package:runnoter/domain/model/blood_test_parameter.dart';

BloodTestParameter createBloodTestParameter({
  String id = '',
  BloodTestParameterType type = BloodTestParameterType.basic,
  String name = '',
  BloodTestParameterUnit unit = BloodTestParameterUnit.femtolitre,
  BloodTestParameterNorm norm = const BloodTestParameterNorm(min: 0, max: 1),
  String? description,
}) =>
    BloodTestParameter(
      id: id,
      type: type,
      name: name,
      unit: unit,
      norm: norm,
      description: description,
    );
