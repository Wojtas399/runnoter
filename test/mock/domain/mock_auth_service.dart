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
    String? userId,
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_signUpCall).thenThrow(throwable);
    } else {
      when(_signUpCall).thenAnswer((invocation) => Future.value(userId));
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
      when(_updatePasswordCall).thenThrow(throwable);
    } else {
      when(_updatePasswordCall).thenAnswer((invocation) => Future.value());
    }
  }

  void mockIsPasswordCorrect({
    bool isCorrect = true,
  }) {
    when(
      () => isPasswordCorrect(
        password: any(named: 'password'),
      ),
    ).thenAnswer((invocation) => Future.value(isCorrect));
  }

  void mockDeleteAccount({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_deleteAccountCall).thenThrow(throwable);
    } else {
      when(
        _deleteAccountCall,
      ).thenAnswer((invocation) => Future.value());
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

  Future<void> _updatePasswordCall() {
    return updatePassword(
      newPassword: any(named: 'newPassword'),
      currentPassword: any(named: 'currentPassword'),
    );
  }

  Future<void> _deleteAccountCall() {
    return deleteAccount(
      password: any(named: 'password'),
    );
  }
}
