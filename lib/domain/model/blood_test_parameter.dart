import 'package:equatable/equatable.dart';

enum BloodTestParameter {
  wbc(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.thousandsPerCubicMilliliter,
    norm: BloodTestParameterNorm(min: 4, max: 10),
  ),
  rbc(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.millionsPerCubicMillimeter,
    norm: BloodTestParameterNorm(min: 4.50, max: 5.80),
  ),
  hgb(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.gramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 13.5, max: 17.5),
  ),
  hct(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.percentage,
    norm: BloodTestParameterNorm(min: 41, max: 54),
  ),
  mcv(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.femtolitre,
    norm: BloodTestParameterNorm(min: 80, max: 97),
  ),
  mch(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.picogramsPerMilliliter,
    norm: BloodTestParameterNorm(min: 27.7, max: 32.2),
  ),
  mchc(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.gramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 32, max: 36),
  ),
  plt(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.thousandsPerCubicMilliliter,
    norm: BloodTestParameterNorm(min: 140, max: 240),
  ),
  totalBilirubin(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 0.20, max: 1.20),
  ),
  alt(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.unitsPerLiter,
    norm: BloodTestParameterNorm(min: 0, max: 55),
  ),
  ast(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.unitsPerLiter,
    norm: BloodTestParameterNorm(min: 5, max: 34),
  ),
  totalCholesterol(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(max: 200),
  ),
  hdl(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(max: 60),
  ),
  ldl(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(max: 135),
  ),
  tg(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(max: 150),
  ),
  iron(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.microgramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 65, max: 175),
  ),
  ferritin(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.nanogramsPerMilliliter,
    norm: BloodTestParameterNorm(min: 21.8, max: 274.7),
  ),
  b12(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 200, max: 360),
  ),
  folicAcid(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.microgramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 250, max: 410),
  ),
  cpk(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.unitsPerLiter,
    norm: BloodTestParameterNorm(min: 30, max: 200),
  ),
  testosterone(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.nanogramsPerMilliliter,
    norm: BloodTestParameterNorm(min: 240.24, max: 870.68),
  ),
  cortisol(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.microgramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 6.2, max: 19.4),
  ),
  d3_25(
    type: BloodTestParameterType.basic,
    unit: BloodTestParameterUnit.nanogramsPerMilliliter,
    norm: BloodTestParameterNorm(min: 30, max: 50),
  ),
  transferrin(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.microgramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 69, max: 240),
  ),
  uibc(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.picogramsPerMilliliter,
    norm: BloodTestParameterNorm(min: 187, max: 883),
  ),
  tibc(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.nanogramsPerMilliliter,
    norm: BloodTestParameterNorm(min: 4.6, max: 18.7),
  ),
  ggtp(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.internationalUnitsPerLiter,
    norm: BloodTestParameterNorm(min: 12.0, max: 64.0),
  ),
  ldh(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.unitsPerLiter,
    norm: BloodTestParameterNorm(min: 125, max: 243),
  ),
  crp(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerLiter,
    norm: BloodTestParameterNorm(max: 5),
  ),
  tp(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.gramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 6.4, max: 8.3),
  ),
  albumin(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.gramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 3.5, max: 5.0),
  ),
  uricAcid(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 3.5, max: 7.2),
  ),
  directBilirubin(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(max: 0.20),
  ),
  glucose(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 60, max: 99),
  ),
  magnesium(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 1.6, max: 2.6),
  ),
  totalCalcium(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.millimolesPerLiter,
    norm: BloodTestParameterNorm(min: 2.10, max: 2.55),
  ),
  sodium(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.millimolesPerLiter,
    norm: BloodTestParameterNorm(min: 136, max: 146),
  ),
  potassium(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.millimolesPerLiter,
    norm: BloodTestParameterNorm(min: 3.6, max: 4.9),
  ),
  zinc(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 50, max: 150),
  ),
  chloride(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.millimolesPerLiter,
    norm: BloodTestParameterNorm(min: 99, max: 109),
  ),
  creatinineKinaseMB(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.nanogramsPerMilliliter,
    norm: BloodTestParameterNorm(max: 7.2),
  ),
  myoglobin(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.nanogramsPerMilliliter,
    norm: BloodTestParameterNorm(min: 25, max: 72),
  ),
  tsh(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.microInternationUnitsPerMilliliter,
    norm: BloodTestParameterNorm(min: 0.270, max: 4.5),
  ),
  urineUreaNitrogen(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 8, max: 26),
  ),
  creatinineInUrine(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 63, max: 166),
  ),
  myoglobinInUrine(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.microgramsPerGramOfCreatinine,
    norm: BloodTestParameterNorm(max: 17),
  ),
  pltInCitratePlasma(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.thousandsPerCubicMilliliter,
    norm: BloodTestParameterNorm(min: 150, max: 440),
  ),
  creatinine(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 0.72, max: 1.25),
  ),
  bloodUreaNitrogen(
    type: BloodTestParameterType.additional,
    unit: BloodTestParameterUnit.milligramsPerDeciliter,
    norm: BloodTestParameterNorm(min: 8, max: 26),
  );

  final BloodTestParameterType type;
  final BloodTestParameterUnit unit;
  final BloodTestParameterNorm norm;

  const BloodTestParameter({
    required this.type,
    required this.unit,
    required this.norm,
  });
}

enum BloodTestParameterType {
  basic,
  additional,
}

enum BloodTestParameterUnit {
  thousandsPerCubicMilliliter,
  millionsPerCubicMillimeter,
  percentage,
  femtolitre,
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

class BloodTestParameterNorm extends Equatable {
  final double? min;
  final double? max;

  const BloodTestParameterNorm({
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
