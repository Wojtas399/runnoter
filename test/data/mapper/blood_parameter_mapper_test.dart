import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_parameter_mapper.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';

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

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.wbc should be mapped to domain BloodParameter.wbc',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.wbc,
        BloodParameter.wbc,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.rbc should be mapped to domain BloodParameter.rbc',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.rbc,
        BloodParameter.rbc,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.hgb should be mapped to domain BloodParameter.hgb',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.hgb,
        BloodParameter.hgb,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.hct should be mapped to domain BloodParameter.hct',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.hct,
        BloodParameter.hct,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.mcv should be mapped to domain BloodParameter.mcv',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.mcv,
        BloodParameter.mcv,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.mch should be mapped to domain BloodParameter.mch',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.mch,
        BloodParameter.mch,
      );
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
      verifyMappingFromDtoType(
        firebase.BloodParameter.plt,
        BloodParameter.plt,
      );
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
      verifyMappingFromDtoType(
        firebase.BloodParameter.alt,
        BloodParameter.alt,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.ast should be mapped to domain BloodParameter.ast',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.ast,
        BloodParameter.ast,
      );
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
      verifyMappingFromDtoType(
        firebase.BloodParameter.hdl,
        BloodParameter.hdl,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.ldl should be mapped to domain BloodParameter.ldl',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.ldl,
        BloodParameter.ldl,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.tg should be mapped to domain BloodParameter.tg',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.tg,
        BloodParameter.tg,
      );
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
      verifyMappingFromDtoType(
        firebase.BloodParameter.b12,
        BloodParameter.b12,
      );
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
      verifyMappingFromDtoType(
        firebase.BloodParameter.cpk,
        BloodParameter.cpk,
      );
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
      verifyMappingFromDtoType(
        firebase.BloodParameter.ldh,
        BloodParameter.ldh,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.crp should be mapped to domain BloodParameter.crp',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.crp,
        BloodParameter.crp,
      );
    },
  );

  test(
    'map blood parameter from dto type, '
    'dto BloodParameter.tp should be mapped to domain BloodParameter.tp',
    () {
      verifyMappingFromDtoType(
        firebase.BloodParameter.tp,
        BloodParameter.tp,
      );
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
      verifyMappingFromDtoType(
        firebase.BloodParameter.tsh,
        BloodParameter.tsh,
      );
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
}
