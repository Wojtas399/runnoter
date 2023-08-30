import '../../domain/additional_model/blood_parameter.dart';
import '../../domain/entity/user.dart';

bool isParameterValueWithinNorm({
  required Gender gender,
  required BloodParameter parameter,
  required double result,
}) {
  final BloodParameterNorm norm = parameter.norm;
  return switch (norm) {
    BloodParameterNormGeneral() => _checkResult(result, norm.range),
    BloodParameterNormGenderDependent() => switch (gender) {
        Gender.male => _checkResult(result, norm.maleRange),
        Gender.female => _checkResult(result, norm.femaleRange),
      },
  };
}

bool _checkResult(
  double result,
  Range normRange,
) =>
    switch (normRange.min) {
      null => result <= normRange.max,
      double() => result >= normRange.min! && result <= normRange.max,
    };
