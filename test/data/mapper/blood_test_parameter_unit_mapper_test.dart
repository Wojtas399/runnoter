import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_test_parameter_unit_mapper.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';

void main() {
  test(
    'map blood test parameter unit from dto, '
    'thousands per cubic milliliter, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit =
          firebase.BloodTestParameterUnit.thousandsPerCubicMilliliter;
      const domainUnit = BloodTestParameterUnit.thousandsPerCubicMilliliter;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'millions per cubic millimeter, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit =
          firebase.BloodTestParameterUnit.millionsPerCubicMillimeter;
      const domainUnit = BloodTestParameterUnit.millionsPerCubicMillimeter;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'grams per decilitre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.gramsPerDecilitre;
      const domainUnit = BloodTestParameterUnit.gramsPerDecilitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'percentage, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.percentage;
      const domainUnit = BloodTestParameterUnit.percentage;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'femtolitre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.femtolitre;
      const domainUnit = BloodTestParameterUnit.femtolitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'picograms per millilitre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.picogramsPerMillilitre;
      const domainUnit = BloodTestParameterUnit.picogramsPerMillilitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'nanograms per millilitre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.nanogramsPerMillilitre;
      const domainUnit = BloodTestParameterUnit.nanogramsPerMillilitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'milligrams per decilitre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.milligramsPerDecilitre;
      const domainUnit = BloodTestParameterUnit.milligramsPerDecilitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'units per litre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.unitsPerLitre;
      const domainUnit = BloodTestParameterUnit.unitsPerLitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'international units per litre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit =
          firebase.BloodTestParameterUnit.internationalUnitsPerLitre;
      const domainUnit = BloodTestParameterUnit.internationalUnitsPerLitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );

  test(
    'map blood test parameter unit from dto, '
    'millimoles per litre, '
    'should map dto unit to domain unit',
    () {
      const dtoUnit = firebase.BloodTestParameterUnit.millimolesPerLitre;
      const domainUnit = BloodTestParameterUnit.millimolesPerLitre;

      final mappedUnit = mapBloodTestParameterUnitFromDto(dtoUnit);

      expect(mappedUnit, domainUnit);
    },
  );
}
