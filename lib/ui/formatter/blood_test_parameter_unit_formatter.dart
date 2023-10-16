import '../../data/entity/blood_test.dart';

extension BloodParameterUnitFormatter on BloodParameterUnit {
  String toUIFormat() => switch (this) {
        BloodParameterUnit.thousandsPerCubicMilliliter => 'K/ul',
        BloodParameterUnit.millionsPerCubicMillimeter => 'M/ul',
        BloodParameterUnit.percentage => '%',
        BloodParameterUnit.femtoliter => 'fL',
        BloodParameterUnit.picogramsPerMilliliter => 'pg/mL',
        BloodParameterUnit.nanogramsPerMilliliter => 'ng/mL',
        BloodParameterUnit.microgramsPerDeciliter => 'ug/dL',
        BloodParameterUnit.gramsPerDeciliter => 'g/dL',
        BloodParameterUnit.milligramsPerDeciliter => 'mg/dL',
        BloodParameterUnit.milligramsPerLiter => 'mg/L',
        BloodParameterUnit.unitsPerLiter => 'U/L',
        BloodParameterUnit.internationalUnitsPerLiter => 'IU/L',
        BloodParameterUnit.microInternationUnitsPerMilliliter => 'uIU/mL',
        BloodParameterUnit.millimolesPerLiter => 'mmol/L',
        BloodParameterUnit.microgramsPerGramOfCreatinine => 'ug/1g creatinine',
      };
}
