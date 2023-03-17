import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/service/auth_service.dart';
import '../../../component/bloc_with_status_listener_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../service/connectivity_service.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import '../bloc/sign_up_bloc.dart';
import '../bloc/sign_up_state.dart';
import 'sign_up_content.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: SignUpContent(),
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
      create: (_) => SignUpBloc(
        authService: context.read<AuthService>(),
        connectivityService: ConnectivityService(),
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
    return BlocWithStatusListener<SignUpBloc, SignUpState, SignUpInfo,
        SignUpError>(
      child: child,
      onCompleteStatusChanged: (SignUpInfo info) {
        _manageCompletionInfo(info, context);
      },
      onErrorStatusChanged: (SignUpError error) {
        _manageError(error, context);
      },
    );
  }

  Future<void> _manageCompletionInfo(
    SignUpInfo info,
    BuildContext context,
  ) async {
    switch (info) {
      case SignUpInfo.signedUp:
        navigateTo(
          context: context,
          route: Routes.home,
        );
        break;
    }
  }

  Future<void> _manageError(
    SignUpError error,
    BuildContext context,
  ) async {
    switch (error) {
      case SignUpError.emailAlreadyInUse:
        await showMessageDialog(
          context: context,
          title: AppLocalizations.of(context)!
              .sign_up_screen_already_taken_email_dialog_title,
          message: AppLocalizations.of(context)!
              .sign_up_screen_already_taken_email_dialog_message,
        );
        break;
    }
  }
}
