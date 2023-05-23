import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/blood_test_parameter.dart';

extension BloodTestParameterFormatter on BloodTestParameter {
  String toName(BuildContext context) {
    final str = Str.of(context);
    return switch (this) {
      BloodTestParameter.wbc => str.bloodParamWBC,
      BloodTestParameter.rbc => str.bloodParamRBC,
      BloodTestParameter.hgb => str.bloodParamHGB,
      BloodTestParameter.hct => str.bloodParamHCT,
      BloodTestParameter.mcv => str.bloodParamMCV,
      BloodTestParameter.mch => str.bloodParamMCH,
      BloodTestParameter.mchc => str.bloodParamMCHC,
      BloodTestParameter.plt => str.bloodParamPLT,
      BloodTestParameter.totalBilirubin => str.bloodParamTotalBilirubin,
      BloodTestParameter.alt => str.bloodParamALT,
      BloodTestParameter.ast => str.bloodParamAST,
      BloodTestParameter.totalCholesterol => str.bloodParamTotalCholesterol,
      BloodTestParameter.hdl => str.bloodParamHDL,
      BloodTestParameter.ldl => str.bloodParamLDL,
      BloodTestParameter.tg => str.bloodParamTG,
      BloodTestParameter.iron => str.bloodParamIron,
      BloodTestParameter.ferritin => str.bloodParamFerritin,
      BloodTestParameter.b12 => str.bloodParamB12,
      BloodTestParameter.folicAcid => str.bloodParamFolicAcid,
      BloodTestParameter.cpk => str.bloodParamCPK,
      BloodTestParameter.testosterone => str.bloodParamTestosterone,
      BloodTestParameter.cortisol => str.bloodParamCortisol,
      BloodTestParameter.d3_25 => str.bloodParamD3_25,
      BloodTestParameter.transferrin => str.bloodParamTransferrin,
      BloodTestParameter.uibc => str.bloodParamUIBC,
      BloodTestParameter.tibc => str.bloodParamTIBC,
      BloodTestParameter.ggtp => str.bloodParamGGTP,
      BloodTestParameter.ldh => str.bloodParamLDH,
      BloodTestParameter.crp => str.bloodParamCRP,
      BloodTestParameter.tp => str.bloodParamTP,
      BloodTestParameter.albumin => str.bloodParamAlbumin,
      BloodTestParameter.uricAcid => str.bloodParamUricAcid,
      BloodTestParameter.directBilirubin => str.bloodParamDirectBilirubin,
      BloodTestParameter.glucose => str.bloodParamGlucose,
      BloodTestParameter.magnesium => str.bloodParamMagnesium,
      BloodTestParameter.totalCalcium => str.bloodParamTotalCalcium,
      BloodTestParameter.sodium => str.bloodParamSodium,
      BloodTestParameter.potassium => str.bloodParamPotassium,
      BloodTestParameter.zinc => str.bloodParamZinc,
      BloodTestParameter.chloride => str.bloodParamChloride,
      BloodTestParameter.creatinineKinaseMB => str.bloodParamCreatinineKinaseMB,
      BloodTestParameter.myoglobin => str.bloodParamMyoglobin,
      BloodTestParameter.tsh => str.bloodParamTSH,
      BloodTestParameter.urineUreaNitrogen => str.bloodParamUrineUreaNitrogen,
      BloodTestParameter.creatinineInUrine => str.bloodParamCreatinineInUrine,
      BloodTestParameter.myoglobinInUrine => str.bloodParamMyoglobinInUrine,
      BloodTestParameter.pltInCitratePlasma => str.bloodParamPLTInCitratePlasma,
      BloodTestParameter.creatinine => str.bloodParamCreatinine,
      BloodTestParameter.bloodUreaNitrogen => str.bloodParamBloodUreaNitrogen,
    };
  }
}
