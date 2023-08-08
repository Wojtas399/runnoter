import '../entity/settings.dart';
import '../entity/user.dart';

abstract class UserRepository {
  Stream<User?> getUserById({required String userId});

  Stream<List<User>?> getUsersByCoachId({required String coachId});

  Future<void> addUser({required User user});

  Future<void> updateUser({
    required String userId,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    String? coachId,
    bool coachIdAsNull = false,
    List<String>? clientIds,
    bool clientIdsAsNull = false,
  });

  Future<void> updateUserSettings({
    required String userId,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  });

  Future<void> deleteUser({required String userId});
}
