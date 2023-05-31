import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseBloodTestService extends Mock
    implements FirebaseBloodTestService {
  void mockLoadAllTests({
    List<BloodTestDto>? bloodTestDtos,
  }) {
    when(
      () => loadAllTests(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(bloodTestDtos));
  }

  void mockAddNewTest({
    BloodTestDto? addedBloodTestDto,
  }) {
    when(
      () => addNewTest(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameterResultDtos: any(named: 'parameterResultDtos'),
      ),
    ).thenAnswer((invocation) => Future.value(addedBloodTestDto));
  }
}
