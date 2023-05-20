import '../model/blood_test_parameter.dart';

abstract interface class BloodTestRepository {
  Future<List<BloodTestParameter>?> loadAllParameters();
}
