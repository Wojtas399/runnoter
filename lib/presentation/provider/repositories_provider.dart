import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../data/repository_impl/user_repository_impl.dart';
import '../../domain/repository/user_repository.dart';

class RepositoriesProvider extends StatelessWidget {
  final Widget child;

  const RepositoriesProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        Provider<UserRepository>(
          create: (_) => UserRepositoryImpl(
            firebaseUserService: FirebaseUserService(),
          ),
        ),
      ],
      child: child,
    );
  }
}