import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseUserService {
  Stream<UserDto?> getUserById({required String userId}) =>
      getUserRef(userId).snapshots().map((snapshot) => snapshot.data());

  Future<UserDto?> loadUserById({required String userId}) async {
    final user = await getUserRef(userId).get();
    return user.data();
  }

  Future<List<UserDto>> loadUsersByCoachId({required String coachId}) async {
    final querySnapshot =
        await getUsersRef().where(coachIdField, isEqualTo: coachId).get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<List<UserDto>> searchForUsers({required String searchQuery}) async {
    final snapshot = await getUsersRef().get();
    final userDtos = snapshot.docs.map((doc) => doc.data());
    return userDtos
        .where(
          (UserDto userDto) =>
              userDto.name.contains(searchQuery) ||
              userDto.surname.contains(searchQuery) ||
              userDto.email.contains(searchQuery),
        )
        .toList();
  }

  Future<UserDto?> addUserData({required UserDto userDto}) async {
    final userRef = getUserRef(userDto.id);
    await asyncOrSyncCall(() => userRef.set(userDto));
    final snapshot = await userRef.get();
    return snapshot.data();
  }

  Future<UserDto?> updateUserData({
    required String userId,
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    String? coachId,
    bool coachIdAsNull = false,
  }) async {
    final userRef = getUserRef(userId);
    final userJsonToUpdate = createUserJsonToUpdate(
      accountType: accountType,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      coachId: coachId,
      coachIdAsNull: coachIdAsNull,
    );
    await asyncOrSyncCall(() => userRef.update(userJsonToUpdate));
    final user = await userRef.get();
    return user.data();
  }

  Future<void> deleteUserData({required String userId}) async {
    await asyncOrSyncCall(() => getUserRef(userId).delete());
  }
}
