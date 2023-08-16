import '../additional_model/settings.dart';
import '../entity/user.dart';

abstract class UserRepository {
  Stream<User?> getUserById({required String userId});

  Future<void> addUser({required User user});

  Future<void> updateUser({
    required String userId,
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    String? coachId,
    bool coachIdAsNull = false,
  });

  Future<void> updateUserSettings({
    required String userId,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  });

  Future<void> refreshUserById({required String userId});

  Future<void> deleteUser({required String userId});
}
