import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/forgot_password/forgot_password_bloc.dart';
import '../../../domain/service/auth_service.dart';
import '../../../domain/service/connectivity_service.dart';
import '../../component/app_bar_with_logo.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/text_field_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'forgot_password_content.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({
    super.key,
  });

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
        connectivityService: ConnectivityService(),
      ),
      child: child,
    );
  }
}

class _BlocListener extends StatefulWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlocListenerState();
  }
}

class _BlocListenerState extends State<_BlocListener> {
  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ForgotPasswordBloc, ForgotPasswordState,
        ForgotPasswordBlocInfo, ForgotPasswordBlocError>(
      onInfo: (ForgotPasswordBlocInfo info) {
        _manageCompleteStatus(info, context);
      },
      child: widget.child,
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
        if (mounted) {
          navigateBack(context: context);
        }
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
      context: context,
      title: Str.of(context).forgotPasswordSentEmailDialogTitle,
      message: Str.of(context).forgotPasswordSentEmailDialogMessage,
    );
  }

  void _showMessageAboutInvalidEmail(BuildContext context) {
    showMessageDialog(
      context: context,
      title: Str.of(context).forgotPasswordInvalidEmailDialogTitle,
      message: Str.of(context).forgotPasswordInvalidEmailDialogMessage,
    );
  }

  void _showMessageAboutNotFoundedUser(BuildContext context) {
    showMessageDialog(
      context: context,
      title: Str.of(context).forgotPasswordUserNotFoundDialogTitle,
      message: Str.of(context).forgotPasswordUserNotFoundDialogMessage,
    );
  }
}