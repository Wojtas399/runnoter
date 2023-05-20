import 'package:equatable/equatable.dart';

class BloodTestParameter extends Equatable {
  final String id;
  final BloodTestParameterType type;
  final String name;
  final BloodTestParameterUnit unit;
  final BloodTestParameterNorm norm;
  final String? description;

  const BloodTestParameter({
    required this.id,
    required this.type,
    required this.name,
    required this.unit,
    required this.norm,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        unit,
        norm,
        description,
      ];
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

class BloodTestParameterNorm extends Equatable {
  final double? min;
  final double? max;

  const BloodTestParameterNorm({
    required this.min,
    required this.max,
  }) : assert(min != null || max != null);

  @override
  List<Object?> get props => [
        min,
        max,
      ];
}
