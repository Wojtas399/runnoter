part of firebase;

class FirebaseUserService {
  Stream<UserDto?> getUser({
    required String userId,
  }) {
    return getUserRef(userId).snapshots().map(
          (DocumentSnapshot<UserDto> snapshot) => snapshot.data(),
        );
  }

  Future<void> addUserPersonalData({
    required String userId,
    required String name,
    required String surname,
  }) async {
    final UserDto userDto = UserDto(name: name, surname: surname);
    await getUserRef(userId).set(userDto);
  }
}
