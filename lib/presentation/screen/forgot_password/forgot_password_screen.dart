import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/forgot_password/forgot_password_bloc.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'forgot_password_content.dart';

@RoutePage()
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: ForgotPasswordContent(),
      ),
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

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ForgotPasswordBloc, ForgotPasswordState,
        ForgotPasswordBlocInfo, ForgotPasswordBlocError>(
      onInfo: (ForgotPasswordBlocInfo info) {
        _manageCompleteStatus(info, context);
      },
      child: child,
      onError: (ForgotPasswordBlocError error) {
        _manageErrorStatus(error, context);
      },
    );
  }

  Future<void> _manageCompleteStatus(
    ForgotPasswordBlocInfo info,
    BuildContext context,
  ) async {
    switch (info) {
      case ForgotPasswordBlocInfo.emailSubmitted:
        await _showMessageAboutSubmittedEmail(context);
        navigateBack();
        break;
    }
  }

  void _manageErrorStatus(
    ForgotPasswordBlocError error,
    BuildContext context,
  ) {
    switch (error) {
      case ForgotPasswordBlocError.invalidEmail:
        _showMessageAboutInvalidEmail(context);
        break;
      case ForgotPasswordBlocError.userNotFound:
        _showMessageAboutNotFoundedUser(context);
        break;
    }
  }

  Future<void> _showMessageAboutSubmittedEmail(BuildContext context) async {
    await showMessageDialog(
      title: Str.of(context).forgotPasswordSentEmailDialogTitle,
      message: Str.of(context).forgotPasswordSentEmailDialogMessage,
    );
  }

  void _showMessageAboutInvalidEmail(BuildContext context) {
    showMessageDialog(
      title: Str.of(context).forgotPasswordInvalidEmailDialogTitle,
      message: Str.of(context).forgotPasswordInvalidEmailDialogMessage,
    );
  }

  void _showMessageAboutNotFoundedUser(BuildContext context) {
    showMessageDialog(
      title: Str.of(context).forgotPasswordUserNotFoundDialogTitle,
      message: Str.of(context).forgotPasswordUserNotFoundDialogMessage,
    );
  }
}
