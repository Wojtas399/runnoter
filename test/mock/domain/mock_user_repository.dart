import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {
  void mockGetUserById({
    User? user,
  }) {
    when(
      () => getUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((invocation) => Stream.value(user));
  }
}
