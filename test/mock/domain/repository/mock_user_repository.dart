import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';

class _FakeUser extends Fake implements User {}

class MockUserRepository extends Mock implements UserRepository {
  MockUserRepository() {
    registerFallbackValue(_FakeUser());
  }

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

  void mockUpdateUserSettings({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_updateUserSettingsCall).thenThrow(throwable);
    } else {
      when(_updateUserSettingsCall).thenAnswer((invocation) => Future.value());
    }
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  Future<void> _updateUserSettingsCall() {
    return updateUserSettings(
      userId: any(named: 'userId'),
      themeMode: any(named: 'themeMode'),
      language: any(named: 'language'),
      distanceUnit: any(named: 'distanceUnit'),
      paceUnit: any(named: 'paceUnit'),
    );
  }
}
