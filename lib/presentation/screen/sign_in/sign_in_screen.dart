import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/sign_in/sign_in_cubit.dart';
import '../../component/cubit_with_status_listener_component.dart';
import '../../config/navigation/router.dart';
import '../../dialog/email_verification/email_verification_dialog.dart';
import '../../dialog/required_data_completion/required_data_completion_dialog.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit()..initialize(),
      child: const _CubitListener(
        child: SignInContent(),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<SignInCubit, SignInState, SignInCubitInfo,
        SignInCubitError>(
      onInfo: (SignInCubitInfo info) => _manageInfo(context, info),
      onError: (SignInCubitError error) => _manageError(error, context),
      child: child,
    );
  }

  Future<void> _manageInfo(BuildContext context, SignInCubitInfo info) async {
    switch (info) {
      case SignInCubitInfo.signedIn:
        navigateAndRemoveUntil(const HomeRoute());
        break;
      case SignInCubitInfo.newSignedInUser:
        await _manageNewUser(context);
        break;
    }
  }

  Future<void> _manageError(
      SignInCubitError error, BuildContext context) async {
    final str = Str.of(context);
    switch (error) {
      case SignInCubitError.invalidEmail:
        await showMessageDialog(
          title: str.signInInvalidEmailDialogTitle,
          message: str.signInInvalidEmailDialogMessage,
        );
        break;
      case SignInCubitError.unverifiedEmail:
        showDialogDependingOnScreenSize(const EmailVerificationDialog());
        break;
      case SignInCubitError.userNotFound:
        await showMessageDialog(
          title: str.signInUserNotFoundDialogTitle,
          message: '${str.signInUserNotFoundDialogMessage}...',
        );
        break;
      case SignInCubitError.wrongPassword:
        await showMessageDialog(
          title: str.signInWrongPasswordDialogTitle,
          message: str.signInWrongPasswordDialogMessage,
        );
        break;
    }
  }

  Future<void> _manageNewUser(BuildContext context) async {
    final SignInCubit cubit = context.read<SignInCubit>();
    final bool wantToCreateAccount =
        await _askForConfirmationToCreateAccount(context);
    if (wantToCreateAccount) {
      final bool hasDataBeenAdded = await showDialogDependingOnScreenSize(
        const RequiredDataCompletionDialog(),
      );
      if (hasDataBeenAdded) {
        await showDialogDependingOnScreenSize(const EmailVerificationDialog());
        return;
      }
    }
    cubit.deleteRecentlyCreatedAccount();
  }

  Future<bool> _askForConfirmationToCreateAccount(BuildContext context) async {
    final str = Str.of(context);
    return await askForConfirmation(
      title: Text(str.signInCreateNewAccountConfirmationDialogTitle),
      content: Text(str.signInCreateNewAccountConfirmationDialogMessage),
      confirmButtonLabel: str.create,
      displayConfirmationButtonAsFilled: true,
      barrierDismissible: false,
    );
  }
}
