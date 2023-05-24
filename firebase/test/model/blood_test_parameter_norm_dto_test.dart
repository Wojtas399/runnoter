import 'package:firebase/model/blood_test_parameter_norm_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'from json, '
    'min and max are not null',
    () {
      const double min = 10.0;
      const double max = 25.0;
      final Map<String, dynamic> json = {
        'min': min,
        'max': max,
      };
      const BloodParameterNormDto expectedDto = BloodParameterNormDto(
        min: min,
        max: max,
      );

      final BloodParameterNormDto dto = BloodParameterNormDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'from json, '
    'min is null',
    () {
      const double? min = null;
      const double max = 25.0;
      final Map<String, dynamic> json = {
        'min': min,
        'max': max,
      };
      const BloodParameterNormDto expectedDto = BloodParameterNormDto(
        min: min,
        max: max,
      );

      final BloodParameterNormDto dto = BloodParameterNormDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'from json, '
    'max is null',
    () {
      const double min = 10.0;
      const double? max = null;
      final Map<String, dynamic> json = {
        'min': min,
        'max': max,
      };
      const BloodParameterNormDto expectedDto = BloodParameterNormDto(
        min: min,
        max: max,
      );

      final BloodParameterNormDto dto = BloodParameterNormDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'min and max arent null',
    () {
      const double min = 10.0;
      const double max = 25.0;
      const BloodParameterNormDto dto = BloodParameterNormDto(
        min: min,
        max: max,
      );
      final Map<String, dynamic> expectedJson = {
        'min': min,
        'max': max,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'min is null',
    () {
      const double? min = null;
      const double max = 25.0;
      const BloodParameterNormDto dto = BloodParameterNormDto(
        min: min,
        max: max,
      );
      final Map<String, dynamic> expectedJson = {
        'min': min,
        'max': max,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );

  test(
    'to json, '
    'max is null',
    () {
      const double min = 10.0;
      const double? max = null;
      const BloodParameterNormDto dto = BloodParameterNormDto(
        min: min,
        max: max,
      );
      final Map<String, dynamic> expectedJson = {
        'min': min,
        'max': max,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
