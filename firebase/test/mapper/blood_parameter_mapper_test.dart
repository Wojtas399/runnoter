import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/blood_parameter_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void verifyMappingFromString(
    String parameterStr,
    BloodParameter expectedParameter,
  ) {
    final BloodParameter parameter = mapBloodParameterFromString(parameterStr);

    expect(parameter, expectedParameter);
  }

  void verifyMappingToString(
    BloodParameter parameter,
    String expectedStr,
  ) {
    final str = mapBloodParameterToString(parameter);

    expect(str, expectedStr);
  }

  test(
    'map blood parameter from string, '
    '"wbc" should be mapped to BloodParameter.wbc',
    () {
      verifyMappingFromString('wbc', BloodParameter.wbc);
    },
  );

  test(
    'map blood parameter from string, '
    '"rbc" should be mapped to BloodParameter.rbc',
    () {
      verifyMappingFromString('rbc', BloodParameter.rbc);
    },
  );

  test(
    'map blood parameter from string, '
    '"hgb" should be mapped to BloodParameter.hgb',
    () {
      verifyMappingFromString('hgb', BloodParameter.hgb);
    },
  );

  test(
    'map blood parameter from string, '
    '"hct" should be mapped to BloodParameter.hct',
    () {
      verifyMappingFromString('hct', BloodParameter.hct);
    },
  );

  test(
    'map blood parameter from string, '
    '"mcv" should be mapped to BloodParameter.mcv',
    () {
      verifyMappingFromString('mcv', BloodParameter.mcv);
    },
  );

  test(
    'map blood parameter from string, '
    '"mch" should be mapped to BloodParameter.mch',
    () {
      verifyMappingFromString('mch', BloodParameter.mch);
    },
  );

  test(
    'map blood parameter from string, '
    '"mchc" should be mapped to BloodParameter.mchc',
    () {
      verifyMappingFromString('mchc', BloodParameter.mchc);
    },
  );

  test(
    'map blood parameter from string, '
    '"plt" should be mapped to BloodParameter.plt',
    () {
      verifyMappingFromString('plt', BloodParameter.plt);
    },
  );

  test(
    'map blood parameter from string, '
    '"totalBilirubin" should be mapped to BloodParameter.totalBilirubin',
    () {
      verifyMappingFromString('totalBilirubin', BloodParameter.totalBilirubin);
    },
  );

  test(
    'map blood parameter from string, '
    '"alt" should be mapped to BloodParameter.alt',
    () {
      verifyMappingFromString('alt', BloodParameter.alt);
    },
  );

  test(
    'map blood parameter from string, '
    '"ast" should be mapped to BloodParameter.ast',
    () {
      verifyMappingFromString('hct', BloodParameter.hct);
    },
  );

  test(
    'map blood parameter from string, '
    '"totalCholesterol" should be mapped to BloodParameter.totalCholesterol',
    () {
      verifyMappingFromString(
        'totalCholesterol',
        BloodParameter.totalCholesterol,
      );
    },
  );

  test(
    'map blood parameter from string, '
    '"hdl" should be mapped to BloodParameter.hdl',
    () {
      verifyMappingFromString('hdl', BloodParameter.hdl);
    },
  );

  test(
    'map blood parameter from string, '
    '"ldl" should be mapped to BloodParameter.ldl',
    () {
      verifyMappingFromString('ldl', BloodParameter.ldl);
    },
  );

  test(
    'map blood parameter from string, '
    '"tg" should be mapped to BloodParameter.tg',
    () {
      verifyMappingFromString('tg', BloodParameter.tg);
    },
  );

  test(
    'map blood parameter from string, '
    '"iron" should be mapped to BloodParameter.iron',
    () {
      verifyMappingFromString('iron', BloodParameter.iron);
    },
  );

  test(
    'map blood parameter from string, '
    '"ferritin" should be mapped to BloodParameter.ferritin',
    () {
      verifyMappingFromString('ferritin', BloodParameter.ferritin);
    },
  );

  test(
    'map blood parameter from string, '
    '"b12" should be mapped to BloodParameter.b12',
    () {
      verifyMappingFromString('b12', BloodParameter.b12);
    },
  );

  test(
    'map blood parameter from string, '
    '"folicAcid" should be mapped to BloodParameter.folicAcid',
    () {
      verifyMappingFromString('folicAcid', BloodParameter.folicAcid);
    },
  );

  test(
    'map blood parameter from string, '
    '"cpk" should be mapped to BloodParameter.cpk',
    () {
      verifyMappingFromString('cpk', BloodParameter.cpk);
    },
  );

  test(
    'map blood parameter from string, '
    '"testosterone" should be mapped to BloodParameter.testosterone',
    () {
      verifyMappingFromString('testosterone', BloodParameter.testosterone);
    },
  );

  test(
    'map blood parameter from string, '
    '"cortisol" should be mapped to BloodParameter.cortisol',
    () {
      verifyMappingFromString('cortisol', BloodParameter.cortisol);
    },
  );

  test(
    'map blood parameter from string, '
    '"d3_25" should be mapped to BloodParameter.d3_25',
    () {
      verifyMappingFromString('d3_25', BloodParameter.d3_25);
    },
  );

  test(
    'map blood parameter from string, '
    '"transferrin" should be mapped to BloodParameter.transferrin',
    () {
      verifyMappingFromString('transferrin', BloodParameter.transferrin);
    },
  );

  test(
    'map blood parameter from string, '
    '"uibc" should be mapped to BloodParameter.uibc',
    () {
      verifyMappingFromString('uibc', BloodParameter.uibc);
    },
  );

  test(
    'map blood parameter from string, '
    '"tibc" should be mapped to BloodParameter.tibc',
    () {
      verifyMappingFromString('tibc', BloodParameter.tibc);
    },
  );

  test(
    'map blood parameter from string, '
    '"ggtp" should be mapped to BloodParameter.ggtp',
    () {
      verifyMappingFromString('ggtp', BloodParameter.ggtp);
    },
  );

  test(
    'map blood parameter from string, '
    '"ldh" should be mapped to BloodParameter.ldh',
    () {
      verifyMappingFromString('ldh', BloodParameter.ldh);
    },
  );

  test(
    'map blood parameter from string, '
    '"crp" should be mapped to BloodParameter.crp',
    () {
      verifyMappingFromString('crp', BloodParameter.crp);
    },
  );

  test(
    'map blood parameter from string, '
    '"tp" should be mapped to BloodParameter.tp',
    () {
      verifyMappingFromString('tp', BloodParameter.tp);
    },
  );

  test(
    'map blood parameter from string, '
    '"albumin" should be mapped to BloodParameter.albumin',
    () {
      verifyMappingFromString('albumin', BloodParameter.albumin);
    },
  );

  test(
    'map blood parameter from string, '
    '"uricAcid" should be mapped to BloodParameter.uricAcid',
    () {
      verifyMappingFromString('uricAcid', BloodParameter.uricAcid);
    },
  );

  test(
    'map blood parameter from string, '
    '"directBilirubin" should be mapped to BloodParameter.directBilirubin',
    () {
      verifyMappingFromString(
        'directBilirubin',
        BloodParameter.directBilirubin,
      );
    },
  );

  test(
    'map blood parameter from string, '
    '"glucose" should be mapped to BloodParameter.glucose',
    () {
      verifyMappingFromString('glucose', BloodParameter.glucose);
    },
  );

  test(
    'map blood parameter from string, '
    '"magnesium" should be mapped to BloodParameter.magnesium',
    () {
      verifyMappingFromString('magnesium', BloodParameter.magnesium);
    },
  );

  test(
    'map blood parameter from string, '
    '"totalCalcium" should be mapped to BloodParameter.totalCalcium',
    () {
      verifyMappingFromString('totalCalcium', BloodParameter.totalCalcium);
    },
  );

  test(
    'map blood parameter from string, '
    '"sodium" should be mapped to BloodParameter.sodium',
    () {
      verifyMappingFromString('sodium', BloodParameter.sodium);
    },
  );

  test(
    'map blood parameter from string, '
    '"potassium" should be mapped to BloodParameter.potassium',
    () {
      verifyMappingFromString('potassium', BloodParameter.potassium);
    },
  );

  test(
    'map blood parameter from string, '
    '"zinc" should be mapped to BloodParameter.zinc',
    () {
      verifyMappingFromString('zinc', BloodParameter.zinc);
    },
  );

  test(
    'map blood parameter from string, '
    '"chloride" should be mapped to BloodParameter.chloride',
    () {
      verifyMappingFromString('chloride', BloodParameter.chloride);
    },
  );

  test(
    'map blood parameter from string, '
    '"creatinineKinaseMB" should be mapped to BloodParameter.creatinineKinaseMB',
    () {
      verifyMappingFromString(
        'creatinineKinaseMB',
        BloodParameter.creatinineKinaseMB,
      );
    },
  );

  test(
    'map blood parameter from string, '
    '"myoglobin" should be mapped to BloodParameter.myoglobin',
    () {
      verifyMappingFromString('myoglobin', BloodParameter.myoglobin);
    },
  );

  test(
    'map blood parameter from string, '
    '"tsh" should be mapped to BloodParameter.tsh',
    () {
      verifyMappingFromString('tsh', BloodParameter.tsh);
    },
  );

  test(
    'map blood parameter from string, '
    '"urineUreaNitrogen" should be mapped to BloodParameter.urineUreaNitrogen',
    () {
      verifyMappingFromString(
        'urineUreaNitrogen',
        BloodParameter.urineUreaNitrogen,
      );
    },
  );

  test(
    'map blood parameter from string, '
    '"creatinineInUrine" should be mapped to BloodParameter.creatinineInUrine',
    () {
      verifyMappingFromString(
        'creatinineInUrine',
        BloodParameter.creatinineInUrine,
      );
    },
  );

  test(
    'map blood parameter from string, '
    '"myoglobinInUrine" should be mapped to BloodParameter.myoglobinInUrine',
    () {
      verifyMappingFromString(
        'myoglobinInUrine',
        BloodParameter.myoglobinInUrine,
      );
    },
  );

  test(
    'map blood parameter from string, '
    '"pltInCitratePlasma" should be mapped to BloodParameter.pltInCitratePlasma',
    () {
      verifyMappingFromString(
        'pltInCitratePlasma',
        BloodParameter.pltInCitratePlasma,
      );
    },
  );

  test(
    'map blood parameter from string, '
    '"creatinine" should be mapped to BloodParameter.creatinine',
    () {
      verifyMappingFromString('creatinine', BloodParameter.creatinine);
    },
  );

  test(
    'map blood parameter from string, '
    '"bloodUreaNitrogen" should be mapped to BloodParameter.bloodUreaNitrogen',
    () {
      verifyMappingFromString(
        'bloodUreaNitrogen',
        BloodParameter.bloodUreaNitrogen,
      );
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.wbc should be mapped to "wbc"',
    () {
      verifyMappingToString(BloodParameter.wbc, 'wbc');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.rbc should be mapped to "rbc"',
    () {
      verifyMappingToString(BloodParameter.rbc, 'rbc');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.hgb should be mapped to "hgb"',
    () {
      verifyMappingToString(BloodParameter.hgb, 'hgb');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.hct should be mapped to "hct"',
    () {
      verifyMappingToString(BloodParameter.hct, 'hct');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.mcv should be mapped to "mcv"',
    () {
      verifyMappingToString(BloodParameter.mcv, 'mcv');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.mch should be mapped to "mch"',
    () {
      verifyMappingToString(BloodParameter.mch, 'mch');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.mchc should be mapped to "mchc"',
    () {
      verifyMappingToString(BloodParameter.mchc, 'mchc');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.plt should be mapped to "plt"',
    () {
      verifyMappingToString(BloodParameter.plt, 'plt');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.totalBilirubin should be mapped to "totalBilirubin"',
    () {
      verifyMappingToString(BloodParameter.totalBilirubin, 'totalBilirubin');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.alt should be mapped to "alt"',
    () {
      verifyMappingToString(BloodParameter.alt, 'alt');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.ast should be mapped to "ast"',
    () {
      verifyMappingToString(BloodParameter.ast, 'ast');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.totalCholesterol should be mapped to "totalCholesterol"',
    () {
      verifyMappingToString(
        BloodParameter.totalCholesterol,
        'totalCholesterol',
      );
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.hdl should be mapped to "hdl"',
    () {
      verifyMappingToString(BloodParameter.hdl, 'hdl');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.ldl should be mapped to "ldl"',
    () {
      verifyMappingToString(BloodParameter.ldl, 'ldl');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.tg should be mapped to "tg"',
    () {
      verifyMappingToString(BloodParameter.tg, 'tg');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.iron should be mapped to "iron"',
    () {
      verifyMappingToString(BloodParameter.iron, 'iron');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.ferritin should be mapped to "ferritin"',
    () {
      verifyMappingToString(BloodParameter.ferritin, 'ferritin');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.b12 should be mapped to "b12"',
    () {
      verifyMappingToString(BloodParameter.b12, 'b12');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.folicAcid should be mapped to "folicAcid"',
    () {
      verifyMappingToString(BloodParameter.folicAcid, 'folicAcid');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.cpk should be mapped to "cpk"',
    () {
      verifyMappingToString(BloodParameter.cpk, 'cpk');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.testosterone should be mapped to "testosterone"',
    () {
      verifyMappingToString(BloodParameter.testosterone, 'testosterone');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.cortisol should be mapped to "cortisol"',
    () {
      verifyMappingToString(BloodParameter.cortisol, 'cortisol');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.d3_25 should be mapped to "d3_25"',
    () {
      verifyMappingToString(BloodParameter.d3_25, 'd3_25');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.transferrin should be mapped to "transferrin"',
    () {
      verifyMappingToString(BloodParameter.transferrin, 'transferrin');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.uibc should be mapped to "uibc"',
    () {
      verifyMappingToString(BloodParameter.uibc, 'uibc');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.tibc should be mapped to "tibc"',
    () {
      verifyMappingToString(BloodParameter.tibc, 'tibc');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.ggtp should be mapped to "ggtp"',
    () {
      verifyMappingToString(BloodParameter.ggtp, 'ggtp');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.ldh should be mapped to "ldh"',
    () {
      verifyMappingToString(BloodParameter.ldh, 'ldh');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.crp should be mapped to "crp"',
    () {
      verifyMappingToString(BloodParameter.crp, 'crp');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.tp should be mapped to "tp"',
    () {
      verifyMappingToString(BloodParameter.tp, 'tp');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.albumin should be mapped to "albumin"',
    () {
      verifyMappingToString(BloodParameter.albumin, 'albumin');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.uricAcid should be mapped to "uricAcid"',
    () {
      verifyMappingToString(BloodParameter.uricAcid, 'uricAcid');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.directBilirubin should be mapped to "directBilirubin"',
    () {
      verifyMappingToString(BloodParameter.directBilirubin, 'directBilirubin');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.glucose should be mapped to "glucose"',
    () {
      verifyMappingToString(BloodParameter.glucose, 'glucose');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.magnesium should be mapped to "magnesium"',
    () {
      verifyMappingToString(BloodParameter.magnesium, 'magnesium');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.totalCalcium should be mapped to "totalCalcium"',
    () {
      verifyMappingToString(BloodParameter.totalCalcium, 'totalCalcium');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.sodium should be mapped to "sodium"',
    () {
      verifyMappingToString(BloodParameter.sodium, 'sodium');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.potassium should be mapped to "potassium"',
    () {
      verifyMappingToString(BloodParameter.potassium, 'potassium');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.zinc should be mapped to "zinc"',
    () {
      verifyMappingToString(BloodParameter.zinc, 'zinc');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.chloride should be mapped to "chloride"',
    () {
      verifyMappingToString(BloodParameter.chloride, 'chloride');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.creatinineKinaseMB should be mapped to "creatinineKinaseMB"',
    () {
      verifyMappingToString(
        BloodParameter.creatinineKinaseMB,
        'creatinineKinaseMB',
      );
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.myoglobin should be mapped to "myoglobin"',
    () {
      verifyMappingToString(BloodParameter.myoglobin, 'myoglobin');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.tsh should be mapped to "tsh"',
    () {
      verifyMappingToString(BloodParameter.tsh, 'tsh');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.urineUreaNitrogen should be mapped to "urineUreaNitrogen"',
    () {
      verifyMappingToString(
        BloodParameter.urineUreaNitrogen,
        'urineUreaNitrogen',
      );
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.creatinineInUrine should be mapped to "creatinineInUrine"',
    () {
      verifyMappingToString(
        BloodParameter.creatinineInUrine,
        'creatinineInUrine',
      );
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.myoglobinInUrine should be mapped to "myoglobinInUrine"',
    () {
      verifyMappingToString(
        BloodParameter.myoglobinInUrine,
        'myoglobinInUrine',
      );
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.pltInCitratePlasma should be mapped to "pltInCitratePlasma"',
    () {
      verifyMappingToString(
        BloodParameter.pltInCitratePlasma,
        'pltInCitratePlasma',
      );
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.creatinine should be mapped to "creatinine"',
    () {
      verifyMappingToString(BloodParameter.creatinine, 'creatinine');
    },
  );

  test(
    'map blood parameter to string, '
    'BloodParameter.bloodUreaNitrogen should be mapped to "bloodUreaNitrogen"',
    () {
      verifyMappingToString(
        BloodParameter.bloodUreaNitrogen,
        'bloodUreaNitrogen',
      );
    },
  );
}
