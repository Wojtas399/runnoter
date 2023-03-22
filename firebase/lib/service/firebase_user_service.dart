part of firebase;

class FirebaseUserService {
  Future<UserDto?> loadUserById({
    required String userId,
  }) async {
    final user = await getUserRef(userId).get();
    return user.data();
  }

  Future<void> addUserPersonalData({
    required String userId,
    required String name,
    required String surname,
  }) async {
    final UserDto userDto = UserDto(
      id: userId,
      name: name,
      surname: surname,
    );
    await getUserRef(userId).set(userDto);
  }
}
