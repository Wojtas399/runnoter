import 'package:equatable/equatable.dart';

import '../mapper/blood_test_parameter_type_mapper.dart';
import '../mapper/blood_test_parameter_unit_mapper.dart';
import 'blood_test_parameter_norm_dto.dart';

class BloodTestParameterDto extends Equatable {
  final String id;
  final BloodTestParameterType type;
  final String name;
  final BloodTestParameterUnit unit;
  final BloodTestParameterNormDto norm;

  const BloodTestParameterDto({
    required this.id,
    required this.type,
    required this.name,
    required this.unit,
    required this.norm,
  });

  BloodTestParameterDto.fromJson({
    required String parameterId,
    required Map<String, dynamic>? json,
  }) : this(
          id: parameterId,
          type: mapBloodTestParameterTypeFromString(json?[_typeField]),
          name: json?[_nameField],
          unit: mapBloodTestParameterUnitFromString(json?[_unitField]),
          norm: BloodTestParameterNormDto.fromJson(json?[_normField]),
        );

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        unit,
        norm,
      ];

  Map<String, dynamic> toJson() => {
        _typeField: mapBloodTestParameterTypeToString(type),
        _nameField: name,
        _unitField: mapBloodTestParameterUnitToString(unit),
        _normField: norm.toJson(),
      };
}

enum BloodTestParameterType {
  basic,
  additional,
}

enum BloodTestParameterUnit {
  thousandsPerCubicMilliliter,
  millionsPerCubicMillimeter,
  gramsPerDecilitre,
  percentage,
  femtolitre,
  picogramsPerMillilitre,
  nanogramsPerMillilitre,
  milligramsPerDecilitre,
  unitsPerLitre,
  internationalUnitsPerLitre,
  millimolesPerLitre,
}

const String _typeField = 'type';
const String _nameField = 'name';
const String _unitField = 'unit';
const String _normField = 'norm';
