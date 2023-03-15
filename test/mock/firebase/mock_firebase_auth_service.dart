import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
  void mockSignIn({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_signInCall).thenThrow(throwable);
    } else {
      when(_signInCall).thenAnswer((_) async => '');
    }
  }

  void mockSignUp({
    String? userId,
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_signUpCall).thenThrow(throwable);
    } else {
      when(_signUpCall).thenAnswer((_) async => userId);
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

  Future<String?> _signUpCall() {
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
