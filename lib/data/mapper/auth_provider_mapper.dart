import 'package:firebase/firebase.dart';

import '../interface/service/auth_service.dart';

FirebaseAuthProvider mapAuthProviderToDb(AuthProvider authProvider) =>
    switch (authProvider) {
      AuthProviderPassword() => FirebaseAuthProviderPassword(
          password: authProvider.password,
        ),
      AuthProviderGoogle() => const FirebaseAuthProviderGoogle(),
      AuthProviderFacebook() => const FirebaseAuthProviderFacebook(),
    };
