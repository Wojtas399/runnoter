import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class FakeUserDto extends Fake implements UserDto {}

class MockFirebaseUserService extends Mock implements FirebaseUserService {
  void mockLoadUserById({
    UserDto? userDto,
  }) {
    when(
      () => loadUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value(userDto));
  }

  void mockAddUserPersonalData() {
    _mockUserDto();
    when(
      () => addUserPersonalData(
        userDto: any(named: 'userDto'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockUpdateUserData({
    UserDto? userDto,
  }) {
    when(
      () => updateUserData(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
      ),
    ).thenAnswer((invocation) => Future.value(userDto));
  }

  void mockDeleteUserData() {
    when(
      () => deleteUserData(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockUserDto() {
    registerFallbackValue(FakeUserDto());
  }
}
