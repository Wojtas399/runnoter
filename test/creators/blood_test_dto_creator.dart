import 'package:firebase/firebase.dart';

BloodTestDto createBloodTestDto({
  String id = '',
  String userId = '',
  DateTime? date,
  List<BloodParameterResultDto> parameterResultDtos = const [
    BloodParameterResultDto(
      parameter: BloodParameter.wbc,
      value: 4.45,
    ),
  ],
}) =>
    BloodTestDto(
      id: id,
      userId: userId,
      date: date ?? DateTime(2023),
      parameterResultDtos: parameterResultDtos,
    );
