import 'package:firebase/firebase.dart' as firebase;

import '../../domain/model/blood_parameter.dart';

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
