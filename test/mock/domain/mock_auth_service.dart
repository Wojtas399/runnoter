import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/service/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  void mockIsUserSignedIn({
    required bool isSignedIn,
  }) {
    when(
      () => isUserSignedIn,
    ).thenReturn(isSignedIn);
  }

  void mockSignIn({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_signInCall).thenThrow(throwable);
    } else {
      when(_signInCall).thenAnswer((_) async => _);
    }
  }

  void mockSignUp({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_signUpCall).thenThrow(throwable);
    } else {
      when(_signUpCall).thenAnswer((invocation) => Future.value());
    }
  }

  void mockSendPasswordResetEmail({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_sendPasswordResetEmailCall).thenThrow(throwable);
    } else {
      when(_sendPasswordResetEmailCall).thenAnswer(
        (invocation) => Future.value(),
      );
    }
  }

  Future<void> _signInCall() {
    return signIn(
      email: any(named: 'email'),
      password: any(named: 'password'),
    );
  }

  Future<void> _signUpCall() {
    return signUp(
      name: any(named: 'name'),
      surname: any(named: 'surname'),
      email: any(named: 'email'),
      password: any(named: 'password'),
    );
  }

  Future<void> _sendPasswordResetEmailCall() {
    return sendPasswordResetEmail(
      email: any(named: 'email'),
    );
  }
}
