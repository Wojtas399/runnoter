import '../../domain/model/blood_test_parameter.dart';

extension BloodTestParameterNormFormatter on BloodTestParameterNorm {
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
