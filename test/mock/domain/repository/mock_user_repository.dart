import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/interface/repository/user_repository.dart';

class _FakeUser extends Fake implements User {}

class MockUserRepository extends Mock implements UserRepository {
  MockUserRepository() {
    registerFallbackValue(_FakeUser());
  }

  void mockGetUserById({
    User? user,
    Stream<User?>? userStream,
  }) {
    when(
      () => getUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => userStream ?? Stream.value(user));
  }

  void mockAddUser() {
    when(
      () => addUser(
        user: any(named: 'user'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateUser({Object? throwable}) {
    if (throwable != null) {
      when(_updateUserCall).thenThrow(throwable);
    } else {
      when(_updateUserCall).thenAnswer((_) => Future.value());
    }
  }

  void mockUpdateUserSettings({Object? throwable}) {
    if (throwable != null) {
      when(_updateUserSettingsCall).thenThrow(throwable);
    } else {
      when(_updateUserSettingsCall).thenAnswer((_) => Future.value());
    }
  }

  void mockRefreshUserById() {
    when(
      () => refreshUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteUser() {
    when(
      () => deleteUser(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Future.value());
  }

  Future<void> _updateUserCall() => updateUser(
        userId: any(named: 'userId'),
        accountType: any(named: 'accountType'),
        gender: any(named: 'gender'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
        email: any(named: 'email'),
        dateOfBirth: any(named: 'dateOfBirth'),
        coachId: any(named: 'coachId'),
        coachIdAsNull: any(named: 'coachIdAsNull'),
      );

  Future<void> _updateUserSettingsCall() => updateUserSettings(
        userId: any(named: 'userId'),
        themeMode: any(named: 'themeMode'),
        language: any(named: 'language'),
        distanceUnit: any(named: 'distanceUnit'),
        paceUnit: any(named: 'paceUnit'),
      );
}
