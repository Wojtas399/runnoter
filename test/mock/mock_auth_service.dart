import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/service/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
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
