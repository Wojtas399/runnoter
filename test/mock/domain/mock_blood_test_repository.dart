import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/blood_test.dart';
import 'package:runnoter/domain/repository/blood_test_repository.dart';

class MockBloodTestRepository extends Mock implements BloodTestRepository {
  void mockGetTestById({
    BloodTest? bloodTest,
  }) {
    when(
      () => getTestById(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(bloodTest));
  }

  void mockGetAllTests({
    List<BloodTest>? tests,
  }) {
    when(
      () => getAllTests(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(tests));
  }

  void mockAddNewTest() {
    when(
      () => addNewTest(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameterResults: any(named: 'parameterResults'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockUpdateTest() {
    when(
      () => updateTest(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteTest() {
    when(
      () => deleteTest(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }
}
