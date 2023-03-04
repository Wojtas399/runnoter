import 'package:mocktail/mocktail.dart';
import 'package:runnoter/auth/auth.dart';

class MockAuth extends Mock implements Auth {
  void mockSignIn({
    String? userId,
  }) {
    when(
      () => signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => userId);
  }
}
