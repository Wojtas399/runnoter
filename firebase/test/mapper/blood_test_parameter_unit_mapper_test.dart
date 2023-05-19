import 'package:firebase/mapper/blood_test_parameter_unit_mapper.dart';
import 'package:firebase/model/blood_test_parameter_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map blood test parameter unit to string, '
    'thousands per cubic milliliter',
    () {
      const unit = BloodTestParameterUnit.thousandsPerCubicMilliliter;
      const String expectedStr = 'thousandsPerCubicMilliliter';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'millions per cubic millimeter',
    () {
      const unit = BloodTestParameterUnit.millionsPerCubicMillimeter;
      const String expectedStr = 'millionsPerCubicMillimeter';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'grams per deciliter',
    () {
      const unit = BloodTestParameterUnit.gramsPerDecilitre;
      const String expectedStr = 'gramsPerDecilitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'percentage',
    () {
      const unit = BloodTestParameterUnit.percentage;
      const String expectedStr = 'percentage';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'femtolitre',
    () {
      const unit = BloodTestParameterUnit.femtolitre;
      const String expectedStr = 'femtolitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'picograms per millilitre',
    () {
      const unit = BloodTestParameterUnit.picogramsPerMillilitre;
      const String expectedStr = 'picogramsPerMillilitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'nanograms per millilitre',
    () {
      const unit = BloodTestParameterUnit.nanogramsPerMillilitre;
      const String expectedStr = 'nanogramsPerMillilitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'milligrams per decilitre',
    () {
      const unit = BloodTestParameterUnit.milligramsPerDecilitre;
      const String expectedStr = 'milligramsPerDecilitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'units per litre',
    () {
      const unit = BloodTestParameterUnit.unitsPerLitre;
      const String expectedStr = 'unitsPerLitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'international units per litre',
    () {
      const unit = BloodTestParameterUnit.internationalUnitsPerLitre;
      const String expectedStr = 'internationalUnitsPerLitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter unit to string, '
    'millimoles per litre',
    () {
      const unit = BloodTestParameterUnit.millimolesPerLitre;
      const String expectedStr = 'millimolesPerLitre';

      final String str = mapBloodTestParameterUnitToString(unit);

      expect(str, expectedStr);
    },
  );

  test(
    'map blood test parameter from string, '
    'thousands per cubic milliliter',
    () {
      const String str = 'millimolesPerLitre';
      const expectedUnit = BloodTestParameterUnit.millimolesPerLitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'millions per cubic millimeter',
    () {
      const String str = 'millionsPerCubicMillimeter';
      const expectedUnit = BloodTestParameterUnit.millionsPerCubicMillimeter;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'grams per decilitre',
    () {
      const String str = 'gramsPerDecilitre';
      const expectedUnit = BloodTestParameterUnit.gramsPerDecilitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'percentage',
    () {
      const String str = 'percentage';
      const expectedUnit = BloodTestParameterUnit.percentage;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'femtolitre',
    () {
      const String str = 'femtolitre';
      const expectedUnit = BloodTestParameterUnit.femtolitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'picograms per millilitre',
    () {
      const String str = 'picogramsPerMillilitre';
      const expectedUnit = BloodTestParameterUnit.picogramsPerMillilitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'nanograms per millilitre',
    () {
      const String str = 'nanogramsPerMillilitre';
      const expectedUnit = BloodTestParameterUnit.nanogramsPerMillilitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'milligrams per decilitre',
    () {
      const String str = 'milligramsPerDecilitre';
      const expectedUnit = BloodTestParameterUnit.milligramsPerDecilitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'units per litre',
    () {
      const String str = 'unitsPerLitre';
      const expectedUnit = BloodTestParameterUnit.unitsPerLitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'international units per litre',
    () {
      const String str = 'internationalUnitsPerLitre';
      const expectedUnit = BloodTestParameterUnit.internationalUnitsPerLitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );

  test(
    'map blood test parameter from string, '
    'millimoles per litre',
    () {
      const String str = 'millimolesPerLitre';
      const expectedUnit = BloodTestParameterUnit.millimolesPerLitre;

      final BloodTestParameterUnit unit =
          mapBloodTestParameterUnitFromString(str);

      expect(unit, expectedUnit);
    },
  );
}
