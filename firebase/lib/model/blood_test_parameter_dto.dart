import 'package:equatable/equatable.dart';

import '../mapper/blood_test_parameter_unit_mapper.dart';
import 'blood_test_parameter_norm_dto.dart';

class BloodTestParameterDto extends Equatable {
  final String id;
  final String userId;
  final String name;
  final BloodTestParameterUnit unit;
  final BloodTestParameterNormDto norm;
  final String? description;

  const BloodTestParameterDto({
    required this.id,
    required this.userId,
    required this.name,
    required this.unit,
    required this.norm,
    this.description,
  });

  BloodTestParameterDto.fromJson({
    required String parameterId,
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          id: parameterId,
          userId: userId,
          name: json?[_nameField],
          unit: mapBloodTestParameterUnitFromString(json?[_unitField]),
          norm: BloodTestParameterNormDto.fromJson(json?[_normField]),
          description: json?[_descriptionField],
        );

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        unit,
        norm,
        description,
      ];

  Map<String, dynamic> toJson() => {
        _nameField: name,
        _unitField: mapBloodTestParameterUnitToString(unit),
        _normField: norm.toJson(),
        _descriptionField: description,
      };
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

const String _nameField = 'name';
const String _unitField = 'unit';
const String _normField = 'norm';
const String _descriptionField = 'description';
