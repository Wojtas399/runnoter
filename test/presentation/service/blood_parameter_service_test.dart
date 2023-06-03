import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';
import 'package:runnoter/presentation/service/blood_parameter_service.dart';

void main() {
  test(
    'is parameter value within norm, '
    'min and max are not null, '
    'result is higher than min and lower than max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.wbc;
      final double result =
          Random().nextDouble() * (parameter.norm.max - parameter.norm.min!) +
              parameter.norm.min!;

      final bool isWithinNorm = isParameterValueWithinNorm(
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'min and max are not null, '
    'result is equal to min, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.wbc;
      final double result = parameter.norm.min!;

      final bool isWithinNorm = isParameterValueWithinNorm(
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'min and max are not null, '
    'result is equal to max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.wbc;
      final double result = parameter.norm.max;

      final bool isWithinNorm = isParameterValueWithinNorm(
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'only max is not null, '
    'result is lower than max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.hdl;
      final double result = parameter.norm.max - 5;

      final bool isWithinNorm = isParameterValueWithinNorm(
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );

  test(
    'is parameter value within norm, '
    'only max is not null, '
    'result is equal to max, '
    'should be true',
    () {
      const BloodParameter parameter = BloodParameter.hdl;
      final double result = parameter.norm.max;

      final bool isWithinNorm = isParameterValueWithinNorm(
        parameter: parameter,
        result: result,
      );

      expect(isWithinNorm, true);
    },
  );
}
