import '../../domain/additional_model/blood_parameter.dart';

extension BloodParameterNormFormatter on Range {
  String toUIFormat() => switch (min) {
        null => '< $max',
        double() => '$min - $max',
      };
}
