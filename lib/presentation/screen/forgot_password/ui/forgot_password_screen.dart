import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/service/auth_service.dart';
import '../bloc/forgot_password_bloc.dart';
import 'forgot_password_content.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: ForgotPasswordContent(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(
        authService: context.read<AuthService>(),
      ),
      child: child,
    );
  }
}
