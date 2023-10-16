import 'package:firebase/firebase.dart' as firebase;

import '../model/blood_test.dart';

BloodParameter mapBloodParameterFromDtoType(
  firebase.BloodParameter dtoParameter,
) =>
    switch (dtoParameter) {
      firebase.BloodParameter.wbc => BloodParameter.wbc,
      firebase.BloodParameter.rbc => BloodParameter.rbc,
      firebase.BloodParameter.hgb => BloodParameter.hgb,
      firebase.BloodParameter.hct => BloodParameter.hct,
      firebase.BloodParameter.mcv => BloodParameter.mcv,
      firebase.BloodParameter.mch => BloodParameter.mch,
      firebase.BloodParameter.mchc => BloodParameter.mchc,
      firebase.BloodParameter.plt => BloodParameter.plt,
      firebase.BloodParameter.totalBilirubin => BloodParameter.totalBilirubin,
      firebase.BloodParameter.alt => BloodParameter.alt,
      firebase.BloodParameter.ast => BloodParameter.ast,
      firebase.BloodParameter.totalCholesterol =>
        BloodParameter.totalCholesterol,
      firebase.BloodParameter.hdl => BloodParameter.hdl,
      firebase.BloodParameter.ldl => BloodParameter.ldl,
      firebase.BloodParameter.tg => BloodParameter.tg,
      firebase.BloodParameter.iron => BloodParameter.iron,
      firebase.BloodParameter.ferritin => BloodParameter.ferritin,
      firebase.BloodParameter.b12 => BloodParameter.b12,
      firebase.BloodParameter.folicAcid => BloodParameter.folicAcid,
      firebase.BloodParameter.cpk => BloodParameter.cpk,
      firebase.BloodParameter.testosterone => BloodParameter.testosterone,
      firebase.BloodParameter.cortisol => BloodParameter.cortisol,
      firebase.BloodParameter.d3_25 => BloodParameter.d3_25,
      firebase.BloodParameter.transferrin => BloodParameter.transferrin,
      firebase.BloodParameter.uibc => BloodParameter.uibc,
      firebase.BloodParameter.tibc => BloodParameter.tibc,
      firebase.BloodParameter.ggtp => BloodParameter.ggtp,
      firebase.BloodParameter.ldh => BloodParameter.ldh,
      firebase.BloodParameter.crp => BloodParameter.crp,
      firebase.BloodParameter.tp => BloodParameter.tp,
      firebase.BloodParameter.albumin => BloodParameter.albumin,
      firebase.BloodParameter.uricAcid => BloodParameter.uricAcid,
      firebase.BloodParameter.directBilirubin => BloodParameter.directBilirubin,
      firebase.BloodParameter.glucose => BloodParameter.glucose,
      firebase.BloodParameter.magnesium => BloodParameter.magnesium,
      firebase.BloodParameter.totalCalcium => BloodParameter.totalCalcium,
      firebase.BloodParameter.sodium => BloodParameter.sodium,
      firebase.BloodParameter.potassium => BloodParameter.potassium,
      firebase.BloodParameter.zinc => BloodParameter.zinc,
      firebase.BloodParameter.chloride => BloodParameter.chloride,
      firebase.BloodParameter.creatinineKinaseMB =>
        BloodParameter.creatinineKinaseMB,
      firebase.BloodParameter.myoglobin => BloodParameter.myoglobin,
      firebase.BloodParameter.tsh => BloodParameter.tsh,
      firebase.BloodParameter.urineUreaNitrogen =>
        BloodParameter.urineUreaNitrogen,
      firebase.BloodParameter.creatinineInUrine =>
        BloodParameter.creatinineInUrine,
      firebase.BloodParameter.myoglobinInUrine =>
        BloodParameter.myoglobinInUrine,
      firebase.BloodParameter.pltInCitratePlasma =>
        BloodParameter.pltInCitratePlasma,
      firebase.BloodParameter.creatinine => BloodParameter.creatinine,
      firebase.BloodParameter.bloodUreaNitrogen =>
        BloodParameter.bloodUreaNitrogen,
    };

firebase.BloodParameter mapBloodParameterToDtoType(
  BloodParameter parameter,
) =>
    switch (parameter) {
      BloodParameter.wbc => firebase.BloodParameter.wbc,
      BloodParameter.rbc => firebase.BloodParameter.rbc,
      BloodParameter.hgb => firebase.BloodParameter.hgb,
      BloodParameter.hct => firebase.BloodParameter.hct,
      BloodParameter.mcv => firebase.BloodParameter.mcv,
      BloodParameter.mch => firebase.BloodParameter.mch,
      BloodParameter.mchc => firebase.BloodParameter.mchc,
      BloodParameter.plt => firebase.BloodParameter.plt,
      BloodParameter.totalBilirubin => firebase.BloodParameter.totalBilirubin,
      BloodParameter.alt => firebase.BloodParameter.alt,
      BloodParameter.ast => firebase.BloodParameter.ast,
      BloodParameter.totalCholesterol =>
        firebase.BloodParameter.totalCholesterol,
      BloodParameter.hdl => firebase.BloodParameter.hdl,
      BloodParameter.ldl => firebase.BloodParameter.ldl,
      BloodParameter.tg => firebase.BloodParameter.tg,
      BloodParameter.iron => firebase.BloodParameter.iron,
      BloodParameter.ferritin => firebase.BloodParameter.ferritin,
      BloodParameter.b12 => firebase.BloodParameter.b12,
      BloodParameter.folicAcid => firebase.BloodParameter.folicAcid,
      BloodParameter.cpk => firebase.BloodParameter.cpk,
      BloodParameter.testosterone => firebase.BloodParameter.testosterone,
      BloodParameter.cortisol => firebase.BloodParameter.cortisol,
      BloodParameter.d3_25 => firebase.BloodParameter.d3_25,
      BloodParameter.transferrin => firebase.BloodParameter.transferrin,
      BloodParameter.uibc => firebase.BloodParameter.uibc,
      BloodParameter.tibc => firebase.BloodParameter.tibc,
      BloodParameter.ggtp => firebase.BloodParameter.ggtp,
      BloodParameter.ldh => firebase.BloodParameter.ldh,
      BloodParameter.crp => firebase.BloodParameter.crp,
      BloodParameter.tp => firebase.BloodParameter.tp,
      BloodParameter.albumin => firebase.BloodParameter.albumin,
      BloodParameter.uricAcid => firebase.BloodParameter.uricAcid,
      BloodParameter.directBilirubin => firebase.BloodParameter.directBilirubin,
      BloodParameter.glucose => firebase.BloodParameter.glucose,
      BloodParameter.magnesium => firebase.BloodParameter.magnesium,
      BloodParameter.totalCalcium => firebase.BloodParameter.totalCalcium,
      BloodParameter.sodium => firebase.BloodParameter.sodium,
      BloodParameter.potassium => firebase.BloodParameter.potassium,
      BloodParameter.zinc => firebase.BloodParameter.zinc,
      BloodParameter.chloride => firebase.BloodParameter.chloride,
      BloodParameter.creatinineKinaseMB =>
        firebase.BloodParameter.creatinineKinaseMB,
      BloodParameter.myoglobin => firebase.BloodParameter.myoglobin,
      BloodParameter.tsh => firebase.BloodParameter.tsh,
      BloodParameter.urineUreaNitrogen =>
        firebase.BloodParameter.urineUreaNitrogen,
      BloodParameter.creatinineInUrine =>
        firebase.BloodParameter.creatinineInUrine,
      BloodParameter.myoglobinInUrine =>
        firebase.BloodParameter.myoglobinInUrine,
      BloodParameter.pltInCitratePlasma =>
        firebase.BloodParameter.pltInCitratePlasma,
      BloodParameter.creatinine => firebase.BloodParameter.creatinine,
      BloodParameter.bloodUreaNitrogen =>
        firebase.BloodParameter.bloodUreaNitrogen,
    };
