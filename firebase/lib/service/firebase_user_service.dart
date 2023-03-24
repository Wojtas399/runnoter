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

  Future<void> updateUserData({
    required String userId,
    String? name,
    String? surname,
  }) async {
    await getUserRef(userId).update(
      createUserDtoJsonToUpdate(
        name: name,
        surname: surname,
      ),
    );
  }
}
