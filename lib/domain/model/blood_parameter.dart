import 'package:equatable/equatable.dart';

class BloodParameterResult extends Equatable {
  final BloodParameter parameter;
  final double value;

  const BloodParameterResult({
    required this.parameter,
    required this.value,
  });

  @override
  List<Object?> get props => [
        parameter,
        value,
      ];
}

enum BloodParameter {
  wbc(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.thousandsPerCubicMilliliter,
    norm: BloodParameterNorm(min: 4, max: 10),
  ),
  rbc(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.millionsPerCubicMillimeter,
    norm: BloodParameterNorm(min: 4.50, max: 5.80),
  ),
  hgb(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.gramsPerDeciliter,
    norm: BloodParameterNorm(min: 13.5, max: 17.5),
  ),
  hct(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.percentage,
    norm: BloodParameterNorm(min: 41, max: 54),
  ),
  mcv(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.femtoliter,
    norm: BloodParameterNorm(min: 80, max: 97),
  ),
  mch(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.picogramsPerMilliliter,
    norm: BloodParameterNorm(min: 27.7, max: 32.2),
  ),
  mchc(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.gramsPerDeciliter,
    norm: BloodParameterNorm(min: 32, max: 36),
  ),
  plt(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.thousandsPerCubicMilliliter,
    norm: BloodParameterNorm(min: 140, max: 240),
  ),
  totalBilirubin(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 0.20, max: 1.20),
  ),
  alt(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.unitsPerLiter,
    norm: BloodParameterNorm(min: 0, max: 55),
  ),
  ast(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.unitsPerLiter,
    norm: BloodParameterNorm(min: 5, max: 34),
  ),
  totalCholesterol(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(max: 200),
  ),
  hdl(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(max: 60),
  ),
  ldl(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(max: 135),
  ),
  tg(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(max: 150),
  ),
  iron(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.microgramsPerDeciliter,
    norm: BloodParameterNorm(min: 65, max: 175),
  ),
  ferritin(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.nanogramsPerMilliliter,
    norm: BloodParameterNorm(min: 21.8, max: 274.7),
  ),
  b12(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 200, max: 360),
  ),
  folicAcid(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.microgramsPerDeciliter,
    norm: BloodParameterNorm(min: 250, max: 410),
  ),
  cpk(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.unitsPerLiter,
    norm: BloodParameterNorm(min: 30, max: 200),
  ),
  testosterone(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.nanogramsPerMilliliter,
    norm: BloodParameterNorm(min: 240.24, max: 870.68),
  ),
  cortisol(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.microgramsPerDeciliter,
    norm: BloodParameterNorm(min: 6.2, max: 19.4),
  ),
  d3_25(
    type: BloodParameterType.basic,
    unit: BloodParameterUnit.nanogramsPerMilliliter,
    norm: BloodParameterNorm(min: 30, max: 50),
  ),
  transferrin(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.microgramsPerDeciliter,
    norm: BloodParameterNorm(min: 69, max: 240),
  ),
  uibc(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.picogramsPerMilliliter,
    norm: BloodParameterNorm(min: 187, max: 883),
  ),
  tibc(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.nanogramsPerMilliliter,
    norm: BloodParameterNorm(min: 4.6, max: 18.7),
  ),
  ggtp(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.internationalUnitsPerLiter,
    norm: BloodParameterNorm(min: 12.0, max: 64.0),
  ),
  ldh(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.unitsPerLiter,
    norm: BloodParameterNorm(min: 125, max: 243),
  ),
  crp(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerLiter,
    norm: BloodParameterNorm(max: 5),
  ),
  tp(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.gramsPerDeciliter,
    norm: BloodParameterNorm(min: 6.4, max: 8.3),
  ),
  albumin(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.gramsPerDeciliter,
    norm: BloodParameterNorm(min: 3.5, max: 5.0),
  ),
  uricAcid(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 3.5, max: 7.2),
  ),
  directBilirubin(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(max: 0.20),
  ),
  glucose(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 60, max: 99),
  ),
  magnesium(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 1.6, max: 2.6),
  ),
  totalCalcium(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.millimolesPerLiter,
    norm: BloodParameterNorm(min: 2.10, max: 2.55),
  ),
  sodium(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.millimolesPerLiter,
    norm: BloodParameterNorm(min: 136, max: 146),
  ),
  potassium(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.millimolesPerLiter,
    norm: BloodParameterNorm(min: 3.6, max: 4.9),
  ),
  zinc(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 50, max: 150),
  ),
  chloride(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.millimolesPerLiter,
    norm: BloodParameterNorm(min: 99, max: 109),
  ),
  creatinineKinaseMB(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.nanogramsPerMilliliter,
    norm: BloodParameterNorm(max: 7.2),
  ),
  myoglobin(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.nanogramsPerMilliliter,
    norm: BloodParameterNorm(min: 25, max: 72),
  ),
  tsh(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.microInternationUnitsPerMilliliter,
    norm: BloodParameterNorm(min: 0.270, max: 4.5),
  ),
  urineUreaNitrogen(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 8, max: 26),
  ),
  creatinineInUrine(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 63, max: 166),
  ),
  myoglobinInUrine(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.microgramsPerGramOfCreatinine,
    norm: BloodParameterNorm(max: 17),
  ),
  pltInCitratePlasma(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.thousandsPerCubicMilliliter,
    norm: BloodParameterNorm(min: 150, max: 440),
  ),
  creatinine(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 0.72, max: 1.25),
  ),
  bloodUreaNitrogen(
    type: BloodParameterType.additional,
    unit: BloodParameterUnit.milligramsPerDeciliter,
    norm: BloodParameterNorm(min: 8, max: 26),
  );

  final BloodParameterType type;
  final BloodParameterUnit unit;
  final BloodParameterNorm norm;

  const BloodParameter({
    required this.type,
    required this.unit,
    required this.norm,
  });
}

enum BloodParameterType {
  basic,
  additional,
}

enum BloodParameterUnit {
  thousandsPerCubicMilliliter,
  millionsPerCubicMillimeter,
  percentage,
  femtoliter,
  picogramsPerMilliliter,
  microgramsPerDeciliter,
  nanogramsPerMilliliter,
  gramsPerDeciliter,
  milligramsPerDeciliter,
  milligramsPerLiter,
  unitsPerLiter,
  internationalUnitsPerLiter,
  microInternationUnitsPerMilliliter,
  millimolesPerLiter,
  microgramsPerGramOfCreatinine,
}

class BloodParameterNorm extends Equatable {
  final double? min;
  final double? max;

  const BloodParameterNorm({
    this.min,
    this.max,
  }) : assert((min != null || max != null) ||
            (min != null && max != null && min < max));

  @override
  List<Object?> get props => [
        min,
        max,
      ];
}
