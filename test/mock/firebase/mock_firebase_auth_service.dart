import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
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

  void mockDeleteAccount({
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_deleteAccount).thenThrow(throwable);
    } else {
      when(_deleteAccount).thenAnswer((invocation) => Future.value());
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

  Future<void> _updateEmailCall() {
    return updateEmail(
      newEmail: any(named: 'newEmail'),
      password: any(named: 'password'),
    );
  }

  Future<void> _updatePasswordCall() {
    return updatePassword(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
    );
  }

  Future<void> _deleteAccount() {
    return deleteAccount(
      password: any(named: 'password'),
    );
  }
}
