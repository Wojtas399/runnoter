import '../../domain/entity/blood_parameter.dart';

extension BloodParameterNormFormatter on Range {
  String toUIFormat() => switch (min) {
        null => '< $max',
        double() => '$min - $max',
      };
}
