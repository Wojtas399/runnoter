import 'package:firebase/firebase.dart' as firebase;

import '../../domain/model/blood_test_parameter.dart';

BloodTestParameterUnit mapBloodTestParameterUnitFromDto(
  firebase.BloodTestParameterUnit dtoUnit,
) =>
    switch (dtoUnit) {
      firebase.BloodTestParameterUnit.thousandsPerCubicMilliliter =>
        BloodTestParameterUnit.thousandsPerCubicMilliliter,
      firebase.BloodTestParameterUnit.millionsPerCubicMillimeter =>
        BloodTestParameterUnit.millionsPerCubicMillimeter,
      firebase.BloodTestParameterUnit.gramsPerDecilitre =>
        BloodTestParameterUnit.gramsPerDecilitre,
      firebase.BloodTestParameterUnit.percentage =>
        BloodTestParameterUnit.percentage,
      firebase.BloodTestParameterUnit.femtolitre =>
        BloodTestParameterUnit.femtolitre,
      firebase.BloodTestParameterUnit.picogramsPerMillilitre =>
        BloodTestParameterUnit.picogramsPerMillilitre,
      firebase.BloodTestParameterUnit.nanogramsPerMillilitre =>
        BloodTestParameterUnit.nanogramsPerMillilitre,
      firebase.BloodTestParameterUnit.milligramsPerDecilitre =>
        BloodTestParameterUnit.milligramsPerDecilitre,
      firebase.BloodTestParameterUnit.unitsPerLitre =>
        BloodTestParameterUnit.unitsPerLitre,
      firebase.BloodTestParameterUnit.internationalUnitsPerLitre =>
        BloodTestParameterUnit.internationalUnitsPerLitre,
      firebase.BloodTestParameterUnit.millimolesPerLitre =>
        BloodTestParameterUnit.millimolesPerLitre,
    };
