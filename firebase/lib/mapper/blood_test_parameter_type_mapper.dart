import '../model/blood_test_parameter_dto.dart';

String mapBloodTestParameterTypeToString(BloodTestParameterType type) =>
    type.name;

BloodTestParameterType mapBloodTestParameterTypeFromString(String str) =>
    BloodTestParameterType.values.byName(str);
