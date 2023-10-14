import 'package:firebase/firebase.dart';

import '../additional_model/auth_provider.dart';

FirebaseAuthProvider mapAuthProviderToDb(AuthProvider authProvider) =>
    switch (authProvider) {
      AuthProviderPassword() => FirebaseAuthProviderPassword(
          password: authProvider.password,
        ),
      AuthProviderGoogle() => const FirebaseAuthProviderGoogle(),
      AuthProviderFacebook() => const FirebaseAuthProviderFacebook(),
    };
