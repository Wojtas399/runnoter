import '../model/user.dart';

abstract class UserRepository {
  Stream<User?> getUserById({
    required String userId,
  });
}
