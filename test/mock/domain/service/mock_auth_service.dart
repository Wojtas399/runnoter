import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/auth_provider.dart';
import 'package:runnoter/domain/service/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  MockAuthService() {
    registerFallbackValue(const AuthProviderGoogle());
  }

  void mockGetLoggedUserId({String? userId}) {
    when(() => loggedUserId$).thenAnswer((_) => Stream.value(userId));
  }

  void mockGetLoggedUserEmail({String? userEmail}) {
    when(() => loggedUserEmail$).thenAnswer((_) => Stream.value(userEmail));
  }

  void mockSignIn({Object? throwable}) {
    if (throwable != null) {
      when(_signInCall).thenThrow(throwable);
    } else {
      when(_signInCall).thenAnswer((_) async => _);
    }
  }

  void mockSignInWithGoogle({Object? throwable}) {
    if (throwable != null) {
      when(signInWithGoogle).thenThrow(throwable);
    } else {
      when(signInWithGoogle).thenAnswer((_) => Future.value());
    }
  }

  void mockSignInWithFacebook({Object? throwable}) {
    if (throwable != null) {
      when(signInWithFacebook).thenThrow(throwable);
    } else {
      when(signInWithFacebook).thenAnswer((_) => Future.value());
    }
  }

  void mockSignUp({String? userId, Object? throwable}) {
    if (throwable != null) {
      when(_signUpCall).thenThrow(throwable);
    } else {
      when(_signUpCall).thenAnswer((_) => Future.value(userId));
    }
  }

  void mockSendPasswordResetEmail({Object? throwable}) {
    if (throwable != null) {
      when(_sendPasswordResetEmailCall).thenThrow(throwable);
    } else {
      when(_sendPasswordResetEmailCall).thenAnswer((_) => Future.value());
    }
  }

  void mockSignOut() {
    when(() => signOut()).thenAnswer((_) => Future.value());
  }

  void mockUpdateEmail({Object? throwable}) {
    if (throwable != null) {
      when(_updateEmailCall).thenThrow(throwable);
    } else {
      when(_updateEmailCall).thenAnswer((_) => Future.value());
    }
  }

  void mockUpdatePassword({Object? throwable}) {
    if (throwable != null) {
      when(_updatePasswordCall).thenThrow(throwable);
    } else {
      when(_updatePasswordCall).thenAnswer((_) => Future.value());
    }
  }

  void mockDeleteAccount({Object? throwable}) {
    if (throwable != null) {
      when(deleteAccount).thenThrow(throwable);
    } else {
      when(deleteAccount).thenAnswer((_) => Future.value());
    }
  }

  Future<void> _signInCall() => signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      );

  Future<String?> _signUpCall() => signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      );

  Future<void> _sendPasswordResetEmailCall() => sendPasswordResetEmail(
        email: any(named: 'email'),
      );

  Future<void> _updateEmailCall() => updateEmail(
        newEmail: any(named: 'newEmail'),
      );

  Future<void> _updatePasswordCall() => updatePassword(
        newPassword: any(named: 'newPassword'),
      );
}
