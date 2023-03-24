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

  void _mockUserDto() {
    registerFallbackValue(FakeUserDto());
  }
}
