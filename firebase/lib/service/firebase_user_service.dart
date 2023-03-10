part of firebase;

class FirebaseUserService {
  Future<void> addUserPersonalData({
    required String userId,
    required String name,
    required String surname,
  }) async {
    final UserDto userDto = UserDto(name: name, surname: surname);
    await getUserRef(userId).set(userDto);
  }
}
