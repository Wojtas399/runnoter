import '../../domain/model/blood_parameter.dart';

bool isParameterValueWithinNorm({
  required BloodParameter parameter,
  required double result,
}) {
  final double? min = parameter.norm.min;
  final double max = parameter.norm.max;
  return switch (min) {
    null => result <= max,
    double() => result >= min && result <= max,
  };
}
