import '../../domain/entity/blood_parameter.dart';

extension BloodParameterNormFormatter on BloodParameterNorm {
  String toUIFormat() => switch (min) {
        null => '< $max',
        double() => '$min - $max',
      };
}
