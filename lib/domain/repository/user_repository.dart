import '../model/user.dart';

abstract class UserRepository {
  Stream<User?> getUserById({
    required String userId,
  });

  Future<void> updateUser({
    required String userId,
    String? name,
    String? surname,
  });
}
