import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/service_impl/auth_service_impl.dart';
import '../../domain/service/auth_service.dart';

class AuthProvider extends StatelessWidget {
  final Widget child;

  const AuthProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthServiceImpl(
        firebaseAuthService: FirebaseAuthService(),
        firebaseUserService: FirebaseUserService(),
      ),
      child: child,
    );
  }
}
