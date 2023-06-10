import 'package:firebase/service/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../data/service_impl/auth_service_impl.dart';
import '../../domain/service/auth_service.dart';
import '../service/distance_unit_service.dart';
import '../service/language_service.dart';
import '../service/theme_service.dart';

class ServicesProvider extends StatelessWidget {
  final Widget child;

  const ServicesProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthServiceImpl(
            firebaseAuthService: FirebaseAuthService(),
          ),
        ),
        BlocProvider<LanguageService>(
          create: (_) => LanguageService(),
        ),
        BlocProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
        BlocProvider(
          create: (_) => DistanceUnitService(),
        ),
      ],
      child: child,
    );
  }
}
