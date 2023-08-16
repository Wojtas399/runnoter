import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';
import '../mapper/account_type_mapper.dart';
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

  Future<List<UserDto>> searchForUsers({
    required String searchQuery,
    AccountType? accountType,
  }) async {
    final CollectionReference<UserDto> usersRef = getUsersRef();
    QuerySnapshot<UserDto> snapshot;
    if (accountType != null) {
      snapshot = await usersRef
          .where(accountTypeField, isEqualTo: mapAccountTypeToStr(accountType))
          .get();
    } else {
      snapshot = await usersRef.get();
    }
    final userDtos = snapshot.docs.map((doc) => doc.data());
    return userDtos.where(
      (UserDto userDto) {
        final String lowerCaseSearchQuery = searchQuery.toLowerCase();
        return userDto.name.toLowerCase().contains(lowerCaseSearchQuery) ||
            userDto.surname.toLowerCase().contains(lowerCaseSearchQuery) ||
            userDto.email.toLowerCase().contains(lowerCaseSearchQuery);
      },
    ).toList();
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

  Future<List<UserDto>> setCoachIdAsNullInAllMatchingUsers({
    required String coachId,
  }) async {
    final usersWitchMatchingCoachId =
        await getUsersRef().where(coachIdField, isEqualTo: coachId).get();
    final userRefs = usersWitchMatchingCoachId.docs.map((doc) => doc.reference);
    final batch = FirebaseFirestore.instance.batch();
    for (final user in usersWitchMatchingCoachId.docs) {
      batch.update(user.reference, createUserJsonToUpdate(coachIdAsNull: true));
    }
    await batch.commit();
    final List<UserDto> updatedUsers = [];
    for (final ref in userRefs) {
      final snapshot = await ref.get();
      if (snapshot.data() != null) updatedUsers.add(snapshot.data()!);
    }
    return updatedUsers;
  }

  Future<void> deleteUserData({required String userId}) async {
    await asyncOrSyncCall(() => getUserRef(userId).delete());
  }
}
