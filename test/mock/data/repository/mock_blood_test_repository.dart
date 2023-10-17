import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/blood_test_repository.dart';
import 'package:runnoter/data/model/blood_test.dart';

class MockBloodTestRepository extends Mock implements BloodTestRepository {
  void mockGetTestById({
    BloodTest? bloodTest,
    Stream<BloodTest?>? bloodTestStream,
  }) {
    when(
      () => getTestById(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => bloodTestStream ?? Stream.value(bloodTest));
  }

  void mockGetTestsByUserId({
    List<BloodTest>? tests,
    Stream<List<BloodTest>?>? testsStream,
  }) {
    when(
      () => getTestsByUserId(userId: any(named: 'userId')),
    ).thenAnswer((_) => testsStream ?? Stream.value(tests));
  }

  void mockRefreshTestsByUserId() {
    when(
      () => refreshTestsByUserId(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value());
  }

  void mockAddNewTest() {
    when(
      () => addNewTest(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameterResults: any(named: 'parameterResults'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateTest({Object? throwable}) {
    if (throwable != null) {
      when(_updateTestCall).thenThrow(throwable);
    } else {
      when(_updateTestCall).thenAnswer((_) => Future.value());
    }
  }

  void mockDeleteTest() {
    when(
      () => deleteTest(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteAllUserTests() {
    when(
      () => deleteAllUserTests(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value());
  }

  Future<void> _updateTestCall() => updateTest(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameterResults: any(named: 'parameterResults'),
      );
}
