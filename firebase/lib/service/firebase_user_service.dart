part of firebase;

class FirebaseUserService {
  Future<UserDto?> loadUserById({
    required String userId,
  }) async {
    final user = await getUserRef(userId).get();
    return user.data();
  }

  Future<void> addUserPersonalData({
    required UserDto userDto,
  }) async {
    await getUserRef(userDto.id).set(userDto);
  }

  Future<UserDto?> updateUserData({
    required String userId,
    String? name,
    String? surname,
  }) async {
    final userRef = getUserRef(userId);
    await userRef.update(
      createUserDtoJsonToUpdate(
        name: name,
        surname: surname,
      ),
    );
    final user = await userRef.get();
    return user.data();
  }

  Future<void> deleteUserData({
    required String userId,
  }) async {
    await getUserRef(userId).delete();
  }
}
