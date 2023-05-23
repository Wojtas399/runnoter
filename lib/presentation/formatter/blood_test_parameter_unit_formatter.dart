import '../../domain/model/blood_test_parameter.dart';

extension BloodTestParameterUnitFormatter on BloodTestParameterUnit {
  String toUIFormat() => switch (this) {
        BloodTestParameterUnit.thousandsPerCubicMilliliter => 'K/ul',
        BloodTestParameterUnit.millionsPerCubicMillimeter => 'M/ul',
        BloodTestParameterUnit.percentage => '%',
        BloodTestParameterUnit.femtoliter => 'fL',
        BloodTestParameterUnit.picogramsPerMilliliter => 'pg/mL',
        BloodTestParameterUnit.nanogramsPerMilliliter => 'ng/mL',
        BloodTestParameterUnit.microgramsPerDeciliter => 'ug/dL',
        BloodTestParameterUnit.gramsPerDeciliter => 'g/dL',
        BloodTestParameterUnit.milligramsPerDeciliter => 'mg/dL',
        BloodTestParameterUnit.milligramsPerLiter => 'mg/L',
        BloodTestParameterUnit.unitsPerLiter => 'U/L',
        BloodTestParameterUnit.internationalUnitsPerLiter => 'IU/L',
        BloodTestParameterUnit.microInternationUnitsPerMilliliter => 'uIU/mL',
        BloodTestParameterUnit.millimolesPerLiter => 'mmol/L',
        BloodTestParameterUnit.microgramsPerGramOfCreatinine =>
          'ug/1g creatinine',
      };
}
