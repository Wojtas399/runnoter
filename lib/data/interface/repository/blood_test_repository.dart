import '../../additional_model/blood_parameter.dart';
import '../../entity/blood_test.dart';

abstract interface class BloodTestRepository {
  Stream<BloodTest?> getTestById({
    required String bloodTestId,
    required String userId,
  });

  Stream<List<BloodTest>?> getTestsByUserId({required String userId});

  Future<void> refreshTestsByUserId({required String userId});

  Future<void> addNewTest({
    required String userId,
    required DateTime date,
    required List<BloodParameterResult> parameterResults,
  });

  Future<void> updateTest({
    required String bloodTestId,
    required String userId,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  });

  Future<void> deleteTest({
    required String bloodTestId,
    required String userId,
  });

  Future<void> deleteAllUserTests({required String userId});
}
