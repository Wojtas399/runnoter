import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/entity/blood_test.dart';

extension BloodParameterFormatter on BloodParameter {
  String toName(BuildContext context) {
    final str = Str.of(context);
    return switch (this) {
      BloodParameter.wbc => str.bloodParamWBC,
      BloodParameter.rbc => str.bloodParamRBC,
      BloodParameter.hgb => str.bloodParamHGB,
      BloodParameter.hct => str.bloodParamHCT,
      BloodParameter.mcv => str.bloodParamMCV,
      BloodParameter.mch => str.bloodParamMCH,
      BloodParameter.mchc => str.bloodParamMCHC,
      BloodParameter.plt => str.bloodParamPLT,
      BloodParameter.totalBilirubin => str.bloodParamTotalBilirubin,
      BloodParameter.alt => str.bloodParamALT,
      BloodParameter.ast => str.bloodParamAST,
      BloodParameter.totalCholesterol => str.bloodParamTotalCholesterol,
      BloodParameter.hdl => str.bloodParamHDL,
      BloodParameter.ldl => str.bloodParamLDL,
      BloodParameter.tg => str.bloodParamTG,
      BloodParameter.iron => str.bloodParamIron,
      BloodParameter.ferritin => str.bloodParamFerritin,
      BloodParameter.b12 => str.bloodParamB12,
      BloodParameter.folicAcid => str.bloodParamFolicAcid,
      BloodParameter.cpk => str.bloodParamCPK,
      BloodParameter.testosterone => str.bloodParamTestosterone,
      BloodParameter.cortisol => str.bloodParamCortisol,
      BloodParameter.d3_25 => str.bloodParamD3_25,
      BloodParameter.transferrin => str.bloodParamTransferrin,
      BloodParameter.uibc => str.bloodParamUIBC,
      BloodParameter.tibc => str.bloodParamTIBC,
      BloodParameter.ggtp => str.bloodParamGGTP,
      BloodParameter.ldh => str.bloodParamLDH,
      BloodParameter.crp => str.bloodParamCRP,
      BloodParameter.tp => str.bloodParamTP,
      BloodParameter.albumin => str.bloodParamAlbumin,
      BloodParameter.uricAcid => str.bloodParamUricAcid,
      BloodParameter.directBilirubin => str.bloodParamDirectBilirubin,
      BloodParameter.glucose => str.bloodParamGlucose,
      BloodParameter.magnesium => str.bloodParamMagnesium,
      BloodParameter.totalCalcium => str.bloodParamTotalCalcium,
      BloodParameter.sodium => str.bloodParamSodium,
      BloodParameter.potassium => str.bloodParamPotassium,
      BloodParameter.zinc => str.bloodParamZinc,
      BloodParameter.chloride => str.bloodParamChloride,
      BloodParameter.creatinineKinaseMB => str.bloodParamCreatinineKinaseMB,
      BloodParameter.myoglobin => str.bloodParamMyoglobin,
      BloodParameter.tsh => str.bloodParamTSH,
      BloodParameter.urineUreaNitrogen => str.bloodParamUrineUreaNitrogen,
      BloodParameter.creatinineInUrine => str.bloodParamCreatinineInUrine,
      BloodParameter.myoglobinInUrine => str.bloodParamMyoglobinInUrine,
      BloodParameter.pltInCitratePlasma => str.bloodParamPLTInCitratePlasma,
      BloodParameter.creatinine => str.bloodParamCreatinine,
      BloodParameter.bloodUreaNitrogen => str.bloodParamBloodUreaNitrogen,
    };
  }
}
