import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_up/sign_up_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../dialog/email_verification/email_verification_dialog.dart';
import '../../service/dialog_service.dart';
import 'sign_up_content.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: const _BlocListener(
        child: SignUpContent(),
      ),
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
    return BlocWithStatusListener<SignUpBloc, SignUpState, SignUpBlocInfo,
        SignUpBlocError>(
      onInfo: _manageInfo,
      onError: (SignUpBlocError error) => _manageError(error, context),
      child: child,
    );
  }

  Future<void> _manageInfo(SignUpBlocInfo info) async {
    switch (info) {
      case SignUpBlocInfo.signedUp:
        showDialogDependingOnScreenSize(const EmailVerificationDialog());
        break;
    }
  }

  Future<void> _manageError(
    SignUpBlocError error,
    BuildContext context,
  ) async {
    switch (error) {
      case SignUpBlocError.emailAlreadyInUse:
        await showMessageDialog(
          title: Str.of(context).signUpAlreadyTakenEmailDialogTitle,
          message: Str.of(context).signUpAlreadyTakenEmailDialogMessage,
        );
        break;
    }
  }
}
