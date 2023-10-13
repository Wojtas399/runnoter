import 'package:runnoter/data/entity/blood_test.dart';
import 'package:runnoter/domain/additional_model/blood_parameter.dart';

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
