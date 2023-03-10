part of firebase;

CollectionReference<UserDto> getUsersRef() {
  return FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
        fromFirestore: (snapshot, _) => UserDto.fromJson(
          snapshot.data(),
        ),
        toFirestore: (UserDto fireUser, _) => fireUser.toJson(),
      );
}

DocumentReference<UserDto> getUserRef(String userId) {
  return getUsersRef().doc(userId);
}
