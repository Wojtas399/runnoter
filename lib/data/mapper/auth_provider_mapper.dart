import 'package:firebase/firebase.dart';

import '../../domain/entity/auth_provider.dart';

FirebaseAuthProvider mapAuthProviderToDb(AuthProvider authProvider) =>
    switch (authProvider) {
      AuthProviderPassword() => FirebaseAuthProviderPassword(
          password: authProvider.password,
        ),
      AuthProviderGoogle() => const FirebaseAuthProviderGoogle(),
    };
