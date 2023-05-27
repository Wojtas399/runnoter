import 'package:equatable/equatable.dart';

import '../mapper/blood_parameter_mapper.dart';
import 'blood_parameter.dart';

class BloodReadingParameterDto extends Equatable {
  final BloodParameter parameter;
  final double readingValue;

  const BloodReadingParameterDto({
    required this.parameter,
    required this.readingValue,
  });

  BloodReadingParameterDto.fromJson(Map<String, dynamic>? json)
      : this(
          parameter: mapBloodParameterFromString(json?[_parameterField]),
          readingValue: json?[_readingValueField],
        );

  @override
  List<Object?> get props => [
        parameter,
        readingValue,
      ];

  Map<String, dynamic> toJson() => {
        _parameterField: mapBloodParameterToString(parameter),
        _readingValueField: readingValue,
      };
}

const String _parameterField = 'parameter';
const String _readingValueField = 'readingValue';
