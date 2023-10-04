import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseBloodTestService extends Mock
    implements FirebaseBloodTestService {
  void mockLoadTestById({BloodTestDto? bloodTestDto}) {
    when(
      () => loadTestById(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(bloodTestDto));
  }

  void mockLoadTestsByUserId({List<BloodTestDto>? bloodTestDtos}) {
    when(
      () => loadTestsByUserId(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value(bloodTestDtos));
  }

  void mockAddNewTest({BloodTestDto? addedBloodTestDto}) {
    when(
      () => addNewTest(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameterResultDtos: any(named: 'parameterResultDtos'),
      ),
    ).thenAnswer((_) => Future.value(addedBloodTestDto));
  }

  void mockUpdateTest({BloodTestDto? updatedBloodTestDto, Object? throwable}) {
    if (throwable != null) {
      when(_updateTestCall).thenThrow(throwable);
    } else {
      when(
        _updateTestCall,
      ).thenAnswer((_) => Future.value(updatedBloodTestDto));
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

  void mockDeleteAllUserTests({required List<String> idsOfDeletedTests}) {
    when(
      () => deleteAllUserTests(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value(idsOfDeletedTests));
  }

  Future<BloodTestDto?> _updateTestCall() => updateTest(
        bloodTestId: any(named: 'bloodTestId'),
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        parameterResultDtos: any(named: 'parameterResultDtos'),
      );
}
