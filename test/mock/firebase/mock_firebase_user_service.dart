import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class FakeUserDto extends Fake implements UserDto {}

class MockFirebaseUserService extends Mock implements FirebaseUserService {
  MockFirebaseUserService() {
    registerFallbackValue(FakeUserDto());
  }

  void mockLoadUserById({UserDto? userDto}) {
    when(
      () => loadUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(userDto));
  }

  void mockAddUserData({UserDto? addedUser}) {
    when(
      () => addUserData(
        userDto: any(named: 'userDto'),
      ),
    ).thenAnswer((_) async => Future.value(addedUser));
  }

  void mockUpdateUserData({UserDto? userDto}) {
    when(
      () => updateUserData(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
        email: any(named: 'email'),
        coachId: any(named: 'coachId'),
        coachIdAsNull: any(named: 'coachIdAsNull'),
        clientIds: any(named: 'clientIds'),
        clientIdsAsNull: any(named: 'clientIdsAsNull'),
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
}
