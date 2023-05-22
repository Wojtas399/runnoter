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
          min: (json[_minField] as num).toDouble(),
          max: (json[_maxField] as num).toDouble(),
        );

  Map<String, dynamic> toJson() => {
        _minField: min,
        _maxField: max,
      };
}

const String _minField = 'min';
const String _maxField = 'max';
