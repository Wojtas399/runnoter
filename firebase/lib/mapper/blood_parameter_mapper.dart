import '../firebase.dart';

BloodParameter mapBloodParameterFromString(
  String parameterStr,
) =>
    BloodParameter.values.byName(parameterStr);

String mapBloodParameterToString(BloodParameter parameter) => parameter.name;
