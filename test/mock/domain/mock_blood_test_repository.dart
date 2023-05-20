import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';
import 'package:runnoter/domain/repository/blood_test_repository.dart';

class MockBloodTestRepository extends Mock implements BloodTestRepository {
  void mockLoadAllParameters({
    required List<BloodTestParameter>? parameters,
  }) {
    when(
      () => loadAllParameters(),
    ).thenAnswer((invocation) => Future.value(parameters));
  }
}
