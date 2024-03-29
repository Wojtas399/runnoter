import 'package:runnoter/data/model/blood_test.dart';

BloodTest createBloodTest({
  String id = '',
  String userId = '',
  DateTime? date,
  List<BloodParameterResult> parameterResults = const [
    BloodParameterResult(
      parameter: BloodParameter.wbc,
      value: 4.45,
    ),
  ],
}) =>
    BloodTest(
      id: id,
      userId: userId,
      date: date ?? DateTime(2023),
      parameterResults: parameterResults,
    );
