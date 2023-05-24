import '../../domain/model/blood_parameter.dart';

extension BloodParameterNormFormatter on BloodParameterNorm {
  String toUIFormat() {
    if (min != null && max != null) {
      return '$min - $max';
    } else if (min != null) {
      return '$min <';
    } else if (max != null) {
      return '< $max';
    }
    return '';
  }
}
