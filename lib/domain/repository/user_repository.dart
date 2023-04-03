import '../model/user.dart';

abstract class UserRepository {
  Stream<User?> getUserById({
    required String userId,
  });

  Future<void> addUser({
    required User user,
  });

  Future<void> updateUserIdentities({
    required String userId,
    String? name,
    String? surname,
  });

  Future<void> deleteUser({
    required String userId,
  });
}
