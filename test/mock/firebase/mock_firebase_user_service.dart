import 'package:firebase/firebase.dart';
import 'package:firebase/model/dto/user_dto.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseUserService extends Mock implements FirebaseUserService {
  void mockGetUser({UserDto? userDto}) {
    when(
      () => getUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(userDto));
  }

  void mockAddUserPersonalData() {
    when(
      () => addUserPersonalData(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
      ),
    ).thenAnswer((_) async => '');
  }
}
