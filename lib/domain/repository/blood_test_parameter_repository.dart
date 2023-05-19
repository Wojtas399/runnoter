import '../model/blood_test_parameter.dart';

abstract interface class BloodTestParameterRepository {
  Stream<List<BloodTestParameter>?> getAllParameters();
}
