import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseUserService extends Mock implements FirebaseUserService {
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
