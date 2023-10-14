import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/domain/additional_model/blood_parameter.dart';
import 'package:runnoter/presentation/service/blood_parameter_service.dart';

void main() {
  test(
    'is parameter value within norm, '
    'general norm, '
    'min and max are not null, '
    'result is higher than min and lower than max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.wbc;
      const double result = 5.2;

      final bool isWithinNorm = isParameterValueWithinNorm(
        gender: Gender.male,
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'general norm, '
    'min and max are not null, '
    'result is equal to min, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.wbc;
      const double result = 4;

      final bool isWithinNorm = isParameterValueWithinNorm(
        gender: Gender.male,
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'general norm, '
    'min and max are not null, '
    'result is equal to max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.wbc;
      const double result = 10;

      final bool isWithinNorm = isParameterValueWithinNorm(
        gender: Gender.male,
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'general norm, '
    'only max is not null, '
    'result is lower than max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.hdl;
      const double result = 9;

      final bool isWithinNorm = isParameterValueWithinNorm(
        gender: Gender.male,
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'general norm, '
    'only max is not null, '
    'result is equal to max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.hdl;
      const double result = 10;

      final bool isWithinNorm = isParameterValueWithinNorm(
        gender: Gender.male,
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'gender dependent norm, '
    'female, '
    'should check result for female range',
    () {
      const BloodParameter parameter = BloodParameter.testosterone;
      const double result = 30;

      final bool isWithinNorm = isParameterValueWithinNorm(
        gender: Gender.female,
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'gender dependent norm, '
    'male, '
    'should check result for male range',
    () {
      const BloodParameter parameter = BloodParameter.testosterone;
      const double result = 300;

      final bool isWithinNorm = isParameterValueWithinNorm(
        gender: Gender.male,
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );
}
