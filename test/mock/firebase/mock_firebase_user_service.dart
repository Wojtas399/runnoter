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

  void mockLoadUsersByCoachId({required List<UserDto> users}) {
    when(
      () => loadUsersByCoachId(
        coachId: any(named: 'coachId'),
      ),
    ).thenAnswer((_) => Future.value(users));
  }

  void mockSearchForUsers({required List<UserDto> userDtos}) {
    when(
      () => searchForUsers(
        name: any(named: 'name'),
        surname: any(named: 'surname'),
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) => Future.value(userDtos));
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
        accountType: any(named: 'accountType'),
        gender: any(named: 'gender'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
        email: any(named: 'email'),
        coachId: any(named: 'coachId'),
        coachIdAsNull: any(named: 'coachIdAsNull'),
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
