import '../../data/entity/blood_test.dart';

extension BloodParameterNormFormatter on Range {
  String toUIFormat() => switch (min) {
        null => '< $max',
        double() => '$min - $max',
      };
}
