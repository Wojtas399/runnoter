import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/interface/auth.dart';

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

  Future<void> _signInCall() {
    return signIn(
      email: any(named: 'email'),
      password: any(named: 'password'),
    );
  }
}
