import 'package:equatable/equatable.dart';

import '../mapper/blood_parameter_mapper.dart';
import 'blood_parameter.dart';

class BloodParameterResultDto extends Equatable {
  final BloodParameter parameter;
  final double value;

  const BloodParameterResultDto({
    required this.parameter,
    required this.value,
  });

  BloodParameterResultDto.fromJson(Map<String, dynamic>? json)
      : this(
          parameter: mapBloodParameterFromString(json?[_parameterField]),
          value: (json?[_valueField] as num).toDouble(),
        );

  @override
  List<Object?> get props => [
        parameter,
        value,
      ];

  Map<String, dynamic> toJson() => {
        _parameterField: mapBloodParameterToString(parameter),
        _valueField: value.toDouble(),
      };
}

const String _parameterField = 'parameter';
const String _valueField = 'value';
