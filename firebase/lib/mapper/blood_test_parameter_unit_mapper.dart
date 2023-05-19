import '../model/blood_test_parameter_dto.dart';

String mapBloodTestParameterUnitToString(
  BloodTestParameterUnit unit,
) =>
    unit.name;

BloodTestParameterUnit mapBloodTestParameterUnitFromString(
  String string,
) =>
    BloodTestParameterUnit.values.byName(string);
