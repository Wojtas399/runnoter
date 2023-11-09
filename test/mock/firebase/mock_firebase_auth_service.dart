import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
  MockFirebaseAuthService() {
    registerFallbackValue(const FirebaseAuthProviderGoogle());
  }

  void mockGetLoggedUserId({String? userId}) {
    when(
      () => loggedUserId$,
    ).thenAnswer((invocation) => Stream.value(userId));
  }

  void mockGetLoggedUserEmail({String? userEmail}) {
    when(() => loggedUserEmail$).thenAnswer((_) => Stream.value(userEmail));
  }

  void mockHasLoggedUserVerifiedEmail({bool? expected}) {
    when(
      () => hasLoggedUserVerifiedEmail$,
    ).thenAnswer((_) => Stream.value(expected));
  }

  void mockSignIn({Object? throwable}) {
    if (throwable != null) {
      when(_signInCall).thenThrow(throwable);
    } else {
      when(_signInCall).thenAnswer((_) async => '');
    }
  }

  void mockSignInWithGoogle({String? userId, Object? throwable}) {
    if (throwable != null) {
      when(signInWithGoogle).thenThrow(throwable);
    } else {
      when(signInWithGoogle).thenAnswer((_) => Future.value(userId));
    }
  }

  void mockSignInWithFacebook({String? userId, Object? throwable}) {
    if (throwable != null) {
      when(signInWithFacebook).thenThrow(throwable);
    } else {
      when(signInWithFacebook).thenAnswer((_) => Future.value(userId));
    }
  }

  void mockSignInWithApple({String? userId, Object? throwable}) {
    if (throwable != null) {
      when(signInWithApple).thenThrow(throwable);
    }
    {
      when(signInWithApple).thenAnswer((_) => Future.value(userId));
    }
  }

  void mockSignUp({String? userId, Object? throwable}) {
    if (throwable != null) {
      when(_signUpCall).thenThrow(throwable);
    } else {
      when(_signUpCall).thenAnswer((_) async => userId);
    }
  }

  void mockSendEmailVerification({Object? throwable}) async {
    if (throwable != null) {
      when(sendEmailVerification).thenThrow(throwable);
    } else {
      when(sendEmailVerification).thenAnswer((_) => Future.value());
    }
  }

  void mockSendPasswordResetEmail({Object? throwable}) {
    if (throwable != null) {
      when(_sendPasswordResetEmailCall).thenThrow(throwable);
    } else {
      when(
        _sendPasswordResetEmailCall,
      ).thenAnswer((invocation) => Future.value());
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

  void mockReauthenticate({
    ReauthenticationStatus? reauthenticationStatus,
    Object? throwable,
  }) {
    if (throwable != null) {
      when(_reauthenticateCall).thenThrow(throwable);
    } else {
      when(
        _reauthenticateCall,
      ).thenAnswer((_) => Future.value(reauthenticationStatus));
    }
  }

  void mockReloadLoggedUser({Object? throwable}) {
    if (throwable != null) {
      when(reloadLoggedUser).thenThrow(throwable);
    } else {
      when(reloadLoggedUser).thenAnswer((_) => Future.value());
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
    );
  }

  Future<void> _updatePasswordCall() => updatePassword(
        newPassword: any(named: 'newPassword'),
      );

  Future<ReauthenticationStatus> _reauthenticateCall() => reauthenticate(
        authProvider: any(named: 'authProvider'),
      );
}
