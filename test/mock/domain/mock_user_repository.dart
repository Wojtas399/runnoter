import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';

class _FakeUser extends Fake implements User {}

class MockUserRepository extends Mock implements UserRepository {
  void mockGetUserById({
    User? user,
  }) {
    when(
      () => getUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(user));
  }

  void mockAddUser() {
    _mockUser();
    when(
      () => addUser(
        user: any(named: 'user'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockUpdateUserIdentities() {
    when(
      () => updateUserIdentities(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  void _mockUser() {
    registerFallbackValue(_FakeUser());
  }
}
