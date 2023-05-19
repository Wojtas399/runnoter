import 'package:equatable/equatable.dart';

class BloodTestParameterNormDto extends Equatable {
  final double? min;
  final double? max;

  const BloodTestParameterNormDto({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [
        min,
        max,
      ];

  BloodTestParameterNormDto.fromJson(Map<String, dynamic> json)
      : this(
          min: json[_minField],
          max: json[_maxField],
        );

  Map<String, dynamic> toJson() => {
        _minField: min,
        _maxField: max,
      };
}

const String _minField = 'min';
const String _maxField = 'max';
