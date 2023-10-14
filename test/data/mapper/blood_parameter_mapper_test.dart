import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/blood_parameter.dart';
import 'package:runnoter/data/mapper/blood_parameter_mapper.dart';

void main() {
  void verifyMappingFromDtoType(
    firebase.BloodParameter dtoParameter,
    BloodParameter expectedBloodParameter,
  ) {
    final BloodParameter bloodParameter = mapBloodParameterFromDtoType(
      dtoParameter,
    );

    expect(bloodParameter, expectedBloodParameter);
  }

  void verifyMappingToDtoType(
    BloodParameter parameter,
    firebase.BloodParameter expectedDtoParameter,
  ) {
    final firebase.BloodParameter dtoParameter = mapBloodParameterToDtoType(
      parameter,
    );

    expect(dtoParameter, expectedDtoParameter);
  }

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.wbc should be mapped to domain BloodParameter.wbc',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.wbc, BloodParameter.wbc);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.rbc should be mapped to domain BloodParameter.rbc',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.rbc, BloodParameter.rbc);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.hgb should be mapped to domain BloodParameter.hgb',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.hgb, BloodParameter.hgb);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.hct should be mapped to domain BloodParameter.hct',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.hct, BloodParameter.hct);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.mcv should be mapped to domain BloodParameter.mcv',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.mcv, BloodParameter.mcv);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.mch should be mapped to domain BloodParameter.mch',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.mch, BloodParameter.mch);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.mchc should be mapped to domain BloodParameter.mchc',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.mchc,
        BloodParameter.mchc,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.plt should be mapped to domain BloodParameter.plt',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.plt, BloodParameter.plt);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.totalBilirubin should be mapped to domain BloodParameter.totalBilirubin',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.totalBilirubin,
        BloodParameter.totalBilirubin,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.alt should be mapped to domain BloodParameter.alt',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.alt, BloodParameter.alt);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.ast should be mapped to domain BloodParameter.ast',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.ast, BloodParameter.ast);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.totalCholesterol should be mapped to domain BloodParameter.totalCholesterol',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.totalCholesterol,
        BloodParameter.totalCholesterol,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.hdl should be mapped to domain BloodParameter.hdl',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.hdl, BloodParameter.hdl);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.ldl should be mapped to domain BloodParameter.ldl',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.ldl, BloodParameter.ldl);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.tg should be mapped to domain BloodParameter.tg',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.tg, BloodParameter.tg);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.iron should be mapped to domain BloodParameter.iron',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.iron,
        BloodParameter.iron,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.ferritin should be mapped to domain BloodParameter.ferritin',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.ferritin,
        BloodParameter.ferritin,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.b12 should be mapped to domain BloodParameter.b12',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.b12, BloodParameter.b12);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.folicAcid should be mapped to domain BloodParameter.folicAcid',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.folicAcid,
        BloodParameter.folicAcid,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.cpk should be mapped to domain BloodParameter.cpk',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.cpk, BloodParameter.cpk);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.testosterone should be mapped to domain BloodParameter.testosterone',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.testosterone,
        BloodParameter.testosterone,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.cortisol should be mapped to domain BloodParameter.cortisol',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.cortisol,
        BloodParameter.cortisol,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.d3_25 should be mapped to domain BloodParameter.d3_25',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.d3_25,
        BloodParameter.d3_25,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.transferrin should be mapped to domain BloodParameter.transferrin',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.transferrin,
        BloodParameter.transferrin,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.uibc should be mapped to domain BloodParameter.uibc',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.uibc,
        BloodParameter.uibc,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.tibc should be mapped to domain BloodParameter.tibc',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.tibc,
        BloodParameter.tibc,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.ggtp should be mapped to domain BloodParameter.ggtp',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.ggtp,
        BloodParameter.ggtp,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.ldh should be mapped to domain BloodParameter.ldh',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.ldh, BloodParameter.ldh);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.crp should be mapped to domain BloodParameter.crp',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.crp, BloodParameter.crp);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.tp should be mapped to domain BloodParameter.tp',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.tp, BloodParameter.tp);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.albumin should be mapped to domain BloodParameter.albumin',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.albumin,
        BloodParameter.albumin,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.uricAcid should be mapped to domain BloodParameter.uricAcid',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.uricAcid,
        BloodParameter.uricAcid,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.directBilirubin should be mapped to domain BloodParameter.directBilirubin',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.directBilirubin,
        BloodParameter.directBilirubin,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.glucose should be mapped to domain BloodParameter.glucose',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.glucose,
        BloodParameter.glucose,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.magnesium should be mapped to domain BloodParameter.magnesium',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.magnesium,
        BloodParameter.magnesium,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.totalCalcium should be mapped to domain BloodParameter.totalCalcium',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.totalCalcium,
        BloodParameter.totalCalcium,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.sodium should be mapped to domain BloodParameter.sodium',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.sodium,
        BloodParameter.sodium,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.potassium should be mapped to domain BloodParameter.potassium',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.potassium,
        BloodParameter.potassium,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.zinc should be mapped to domain BloodParameter.zinc',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.zinc,
        BloodParameter.zinc,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.chloride should be mapped to domain BloodParameter.chloride',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.chloride,
        BloodParameter.chloride,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.creatinineKinaseMB should be mapped to domain BloodParameter.creatinineKinaseMB',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.creatinineKinaseMB,
        BloodParameter.creatinineKinaseMB,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.myoglobin should be mapped to domain BloodParameter.myoglobin',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.myoglobin,
        BloodParameter.myoglobin,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.tsh should be mapped to domain BloodParameter.tsh',
    () {
      verifyMappingFromDtoType(firebase.BloodParameter.tsh, BloodParameter.tsh);
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.urineUreaNitrogen should be mapped to domain BloodParameter.urineUreaNitrogen',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.urineUreaNitrogen,
        BloodParameter.urineUreaNitrogen,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.creatinineInUrine should be mapped to domain BloodParameter.creatinineInUrine',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.creatinineInUrine,
        BloodParameter.creatinineInUrine,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.myoglobinInUrine should be mapped to domain BloodParameter.myoglobinInUrine',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.myoglobinInUrine,
        BloodParameter.myoglobinInUrine,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.pltInCitratePlasma should be mapped to domain BloodParameter.pltInCitratePlasma',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.pltInCitratePlasma,
        BloodParameter.pltInCitratePlasma,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.creatinine should be mapped to domain BloodParameter.creatinine',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.creatinine,
        BloodParameter.creatinine,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.bloodUreaNitrogen should be mapped to domain BloodParameter.bloodUreaNitrogen',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.bloodUreaNitrogen,
        BloodParameter.bloodUreaNitrogen,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.wbc should be mapped to dto BloodParameter.wbc',
    () {
      verifyMappingToDtoType(BloodParameter.wbc, firebase.BloodParameter.wbc);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.rbc should be mapped to dto BloodParameter.rbc',
    () {
      verifyMappingToDtoType(BloodParameter.rbc, firebase.BloodParameter.rbc);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.hgb should be mapped to dto BloodParameter.hgb',
    () {
      verifyMappingToDtoType(BloodParameter.hgb, firebase.BloodParameter.hgb);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.hct should be mapped to dto BloodParameter.hct',
    () {
      verifyMappingToDtoType(BloodParameter.hct, firebase.BloodParameter.hct);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.mcv should be mapped to dto BloodParameter.mcv',
    () {
      verifyMappingToDtoType(BloodParameter.mcv, firebase.BloodParameter.mcv);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.mch should be mapped to dto BloodParameter.mch',
    () {
      verifyMappingToDtoType(BloodParameter.mch, firebase.BloodParameter.mch);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.mchc should be mapped to dto BloodParameter.mchc',
    () {
      verifyMappingToDtoType(BloodParameter.mchc, firebase.BloodParameter.mchc);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.plt should be mapped to dto BloodParameter.plt',
    () {
      verifyMappingToDtoType(BloodParameter.plt, firebase.BloodParameter.plt);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.totalBilirubin should be mapped to dto BloodParameter.totalBilirubin',
    () {
      verifyMappingToDtoType(
        BloodParameter.totalBilirubin,
        firebase.BloodParameter.totalBilirubin,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.alt should be mapped to dto BloodParameter.alt',
    () {
      verifyMappingToDtoType(BloodParameter.alt, firebase.BloodParameter.alt);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.ast should be mapped to dto BloodParameter.ast',
    () {
      verifyMappingToDtoType(BloodParameter.ast, firebase.BloodParameter.ast);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.totalCholesterol should be mapped to dto BloodParameter.totalCholesterol',
    () {
      verifyMappingToDtoType(
        BloodParameter.totalCholesterol,
        firebase.BloodParameter.totalCholesterol,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.hdl should be mapped to dto BloodParameter.hdl',
    () {
      verifyMappingToDtoType(BloodParameter.hdl, firebase.BloodParameter.hdl);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.ldl should be mapped to dto BloodParameter.ldl',
    () {
      verifyMappingToDtoType(BloodParameter.ldl, firebase.BloodParameter.ldl);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.tg should be mapped to dto BloodParameter.tg',
    () {
      verifyMappingToDtoType(BloodParameter.tg, firebase.BloodParameter.tg);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.iron should be mapped to dto BloodParameter.iron',
    () {
      verifyMappingToDtoType(BloodParameter.iron, firebase.BloodParameter.iron);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.ferritin should be mapped to dto BloodParameter.ferritin',
    () {
      verifyMappingToDtoType(
        BloodParameter.ferritin,
        firebase.BloodParameter.ferritin,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.b12 should be mapped to dto BloodParameter.b12',
    () {
      verifyMappingToDtoType(BloodParameter.b12, firebase.BloodParameter.b12);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.folicAcid should be mapped to dto BloodParameter.folicAcid',
    () {
      verifyMappingToDtoType(
        BloodParameter.folicAcid,
        firebase.BloodParameter.folicAcid,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.cpk should be mapped to dto BloodParameter.cpk',
    () {
      verifyMappingToDtoType(BloodParameter.cpk, firebase.BloodParameter.cpk);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.testosterone should be mapped to dto BloodParameter.testosterone',
    () {
      verifyMappingToDtoType(
        BloodParameter.testosterone,
        firebase.BloodParameter.testosterone,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.cortisol should be mapped to dto BloodParameter.cortisol',
    () {
      verifyMappingToDtoType(
        BloodParameter.cortisol,
        firebase.BloodParameter.cortisol,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.d3_25 should be mapped to dto BloodParameter.d3_25',
    () {
      verifyMappingToDtoType(
        BloodParameter.d3_25,
        firebase.BloodParameter.d3_25,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.transferrin should be mapped to dto BloodParameter.transferrin',
    () {
      verifyMappingToDtoType(
        BloodParameter.transferrin,
        firebase.BloodParameter.transferrin,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.uibc should be mapped to dto BloodParameter.uibc',
    () {
      verifyMappingToDtoType(BloodParameter.uibc, firebase.BloodParameter.uibc);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.tibc should be mapped to dto BloodParameter.tibc',
    () {
      verifyMappingToDtoType(BloodParameter.tibc, firebase.BloodParameter.tibc);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.ggtp should be mapped to dto BloodParameter.ggtp',
    () {
      verifyMappingToDtoType(BloodParameter.ggtp, firebase.BloodParameter.ggtp);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.ldh should be mapped to dto BloodParameter.ldh',
    () {
      verifyMappingToDtoType(BloodParameter.ldh, firebase.BloodParameter.ldh);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.crp should be mapped to dto BloodParameter.crp',
    () {
      verifyMappingToDtoType(BloodParameter.crp, firebase.BloodParameter.crp);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.tp should be mapped to dto BloodParameter.tp',
    () {
      verifyMappingToDtoType(BloodParameter.tp, firebase.BloodParameter.tp);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.albumin should be mapped to dto BloodParameter.albumin',
    () {
      verifyMappingToDtoType(
        BloodParameter.albumin,
        firebase.BloodParameter.albumin,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.uricAcid should be mapped to dto BloodParameter.uricAcid',
    () {
      verifyMappingToDtoType(
        BloodParameter.uricAcid,
        firebase.BloodParameter.uricAcid,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.directBilirubin should be mapped to dto BloodParameter.directBilirubin',
    () {
      verifyMappingToDtoType(
        BloodParameter.directBilirubin,
        firebase.BloodParameter.directBilirubin,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.glucose should be mapped to dto BloodParameter.glucose',
    () {
      verifyMappingToDtoType(
        BloodParameter.glucose,
        firebase.BloodParameter.glucose,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.magnesium should be mapped to dto BloodParameter.magnesium',
    () {
      verifyMappingToDtoType(
        BloodParameter.magnesium,
        firebase.BloodParameter.magnesium,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.totalCalcium should be mapped to dto BloodParameter.totalCalcium',
    () {
      verifyMappingToDtoType(
        BloodParameter.totalCalcium,
        firebase.BloodParameter.totalCalcium,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.sodium should be mapped to dto BloodParameter.sodium',
    () {
      verifyMappingToDtoType(
        BloodParameter.sodium,
        firebase.BloodParameter.sodium,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.potassium should be mapped to dto BloodParameter.potassium',
    () {
      verifyMappingToDtoType(
        BloodParameter.potassium,
        firebase.BloodParameter.potassium,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.zinc should be mapped to dto BloodParameter.zinc',
    () {
      verifyMappingToDtoType(BloodParameter.zinc, firebase.BloodParameter.zinc);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.chloride should be mapped to dto BloodParameter.chloride',
    () {
      verifyMappingToDtoType(
        BloodParameter.chloride,
        firebase.BloodParameter.chloride,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.creatinineKinaseMB should be mapped to dto BloodParameter.creatinineKinaseMB',
    () {
      verifyMappingToDtoType(
        BloodParameter.creatinineKinaseMB,
        firebase.BloodParameter.creatinineKinaseMB,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.myoglobin should be mapped to dto BloodParameter.myoglobin',
    () {
      verifyMappingToDtoType(
        BloodParameter.myoglobin,
        firebase.BloodParameter.myoglobin,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.tsh should be mapped to dto BloodParameter.tsh',
    () {
      verifyMappingToDtoType(BloodParameter.tsh, firebase.BloodParameter.tsh);
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.urineUreaNitrogen should be mapped to dto BloodParameter.urineUreaNitrogen',
    () {
      verifyMappingToDtoType(
        BloodParameter.urineUreaNitrogen,
        firebase.BloodParameter.urineUreaNitrogen,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.creatinineInUrine should be mapped to dto BloodParameter.creatinineInUrine',
    () {
      verifyMappingToDtoType(
        BloodParameter.creatinineInUrine,
        firebase.BloodParameter.creatinineInUrine,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.myoglobinInUrine should be mapped to dto BloodParameter.myoglobinInUrine',
    () {
      verifyMappingToDtoType(
        BloodParameter.myoglobinInUrine,
        firebase.BloodParameter.myoglobinInUrine,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.pltInCitratePlasma should be mapped to dto BloodParameter.pltInCitratePlasma',
    () {
      verifyMappingToDtoType(
        BloodParameter.pltInCitratePlasma,
        firebase.BloodParameter.pltInCitratePlasma,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.creatinine should be mapped to dto BloodParameter.creatinine',
    () {
      verifyMappingToDtoType(
        BloodParameter.creatinine,
        firebase.BloodParameter.creatinine,
      );
    },
  );

  test(
    'map blood parameter to dto type, '
    'domain BloodParameter.bloodUreaNitrogen should be mapped to dto BloodParameter.bloodUreaNitrogen',
    () {
      verifyMappingToDtoType(
        BloodParameter.bloodUreaNitrogen,
        firebase.BloodParameter.bloodUreaNitrogen,
      );
    },
  );
}
