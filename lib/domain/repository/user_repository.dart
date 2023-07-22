import '../entity/settings.dart';
import '../entity/user.dart';

abstract class UserRepository {
  Stream<User?> getUserById({
    required String userId,
  });

  Future<void> addUser({
    required User user,
  });

  Future<void> updateUserIdentities({
    required String userId,
    Gender? gender,
    String? name,
    String? surname,
  });

  Future<void> updateUserSettings({
    required String userId,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  });

  Future<void> deleteUser({
    required String userId,
  });
}
