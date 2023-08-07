import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseUserService {
  Future<UserDto?> loadUserById({required String userId}) async {
    final user = await getUserRef(userId).get();
    return user.data();
  }

  Future<void> addUserPersonalData({required UserDto userDto}) async {
    await asyncOrSyncCall(() => getUserRef(userDto.id).set(userDto));
  }

  Future<UserDto?> updateUserData({
    required String userId,
    Gender? gender,
    String? name,
    String? surname,
    String? coachId,
    bool coachIdAsNull = false,
    List<String>? clientIds,
    bool clientIdsAsNull = false,
  }) async {
    final userRef = getUserRef(userId);
    final userJsonToUpdate = createUserJsonToUpdate(
      gender: gender,
      name: name,
      surname: surname,
      coachId: coachId,
      coachIdAsNull: coachIdAsNull,
      clientIds: clientIds,
      clientIdsAsNull: clientIdsAsNull,
    );
    await asyncOrSyncCall(() => userRef.update(userJsonToUpdate));
    final user = await userRef.get();
    return user.data();
  }

  Future<void> deleteUserData({required String userId}) async {
    await asyncOrSyncCall(() => getUserRef(userId).delete());
  }
}
