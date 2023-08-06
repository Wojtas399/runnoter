import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class FakeUserDto extends Fake implements UserDto {}

class MockFirebaseUserService extends Mock implements FirebaseUserService {
  void mockLoadUserById({UserDto? userDto}) {
    when(
      () => loadUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(userDto));
  }

  void mockAddUserPersonalData() {
    _mockUserDto();
    when(
      () => addUserPersonalData(
        userDto: any(named: 'userDto'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUserData({UserDto? userDto}) {
    when(
      () => updateUserData(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
        coachId: any(named: 'coachId'),
        coachIdAsNull: any(named: 'coachIdAsNull'),
        idsOfRunners: any(named: 'idsOfRunners'),
        idsOfRunnersAsNull: any(named: 'idsOfRunnersAsNull'),
      ),
    ).thenAnswer((_) => Future.value(userDto));
  }

  void mockDeleteUserData() {
    when(
      () => deleteUserData(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void _mockUserDto() {
    registerFallbackValue(FakeUserDto());
  }
}
