import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/cubit/forgot_password/forgot_password_cubit.dart';
import '../../../component/cubit_with_status_listener_component.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'forgot_password_content.dart';

@RoutePage()
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _CubitListener(
        child: ForgotPasswordContent(),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<ForgotPasswordCubit, ForgotPasswordState,
        ForgotPasswordCubitInfo, ForgotPasswordCubitError>(
      onInfo: (ForgotPasswordCubitInfo info) {
        _manageCompleteStatus(info, context);
      },
      child: child,
      onError: (ForgotPasswordCubitError error) {
        _manageErrorStatus(error, context);
      },
    );
  }

  Future<void> _manageCompleteStatus(
    ForgotPasswordCubitInfo info,
    BuildContext context,
  ) async {
    switch (info) {
      case ForgotPasswordCubitInfo.emailSubmitted:
        await _showMessageAboutSubmittedEmail(context);
        navigateBack();
        break;
    }
  }

  void _manageErrorStatus(
    ForgotPasswordCubitError error,
    BuildContext context,
  ) {
    switch (error) {
      case ForgotPasswordCubitError.invalidEmail:
        _showMessageAboutInvalidEmail(context);
        break;
      case ForgotPasswordCubitError.userNotFound:
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
