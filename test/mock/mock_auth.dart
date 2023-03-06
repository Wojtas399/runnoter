import 'package:mocktail/mocktail.dart';
import 'package:runnoter/auth/auth.dart';

class MockAuth extends Mock implements Auth {
  void mockSignIn({
    String? userId,
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_signInCall).thenThrow(throwable);
    } else {
      when(_signInCall).thenAnswer((_) async => userId);
    }
  }

  Future<String?> _signInCall() {
    return signIn(
      email: any(named: 'email'),
      password: any(named: 'password'),
    );
  }
}
