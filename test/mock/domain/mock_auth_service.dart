import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/service/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  void mockGetLoggedUserId({
    String? userId,
  }) {
    when(
      () => loggedUserId$,
    ).thenAnswer((invocation) => Stream.value(userId));
  }

  void mockGetLoggedUserEmail({
    String? userEmail,
  }) {
    when(
      () => loggedUserEmail$,
    ).thenAnswer((invocation) => Stream.value(userEmail));
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

  void mockSignOut() {
    when(
      () => signOut(),
    ).thenAnswer((invocation) => Future.value());
  }

  void mockUpdateEmail({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_updateEmailCall).thenThrow(throwable);
    } else {
      when(_updateEmailCall).thenAnswer((invocation) => Future.value());
    }
  }

  void mockUpdatePassword({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_updatePassword).thenThrow(throwable);
    } else {
      when(_updatePassword).thenAnswer((invocation) => Future.value());
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

  Future<void> _updateEmailCall() {
    return updateEmail(
      newEmail: any(named: 'newEmail'),
      password: any(named: 'password'),
    );
  }

  Future<void> _updatePassword() {
    return updatePassword(
      newPassword: any(named: 'newPassword'),
      currentPassword: any(named: 'currentPassword'),
    );
  }
}
