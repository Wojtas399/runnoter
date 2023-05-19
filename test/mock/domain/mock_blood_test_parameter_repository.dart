import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';
import 'package:runnoter/domain/repository/blood_test_parameter_repository.dart';

class MockBloodTestParameterRepository extends Mock
    implements BloodTestParameterRepository {
  void mockGetAllParameters({
    required List<BloodTestParameter>? parameters,
  }) {
    when(
      () => getAllParameters(),
    ).thenAnswer((invocation) => Stream.value(parameters));
  }
}
