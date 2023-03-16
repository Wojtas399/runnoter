import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/service/auth_service.dart';
import '../../../component/bloc_with_status_listener_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../service/connectivity_service.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import '../bloc/sign_in_bloc.dart';
import '../bloc/sign_in_state.dart';
import 'sign_in_screen_content.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: SignInContent(),
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
      create: (BuildContext context) => SignInBloc(
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
    return BlocWithStatusListener<SignInBloc, SignInState, SignInInfo,
        SignInError>(
      child: child,
      onCompleteStatusChanged: (SignInInfo info) {
        _manageCompletionInfo(info, context);
      },
      onErrorStatusChanged: (SignInError error) {
        _manageError(error, context);
      },
    );
  }

  Future<void> _manageCompletionInfo(
    SignInInfo info,
    BuildContext context,
  ) async {
    switch (info) {
      case SignInInfo.signedIn:
        navigateTo(
          context: context,
          route: Routes.home,
        );
        break;
    }
  }

  Future<void> _manageError(
    SignInError error,
    BuildContext context,
  ) async {
    switch (error) {
      case SignInError.invalidEmail:
        await showMessageDialog(
          context: context,
          title:
              AppLocalizations.of(context)!.sign_in_screen_invalid_email_title,
          message: AppLocalizations.of(context)!
              .sign_in_screen_invalid_email_message,
        );
        break;
      case SignInError.userNotFound:
        await showMessageDialog(
          context: context,
          title:
              AppLocalizations.of(context)!.sign_in_screen_user_not_found_title,
          message:
              '${AppLocalizations.of(context)!.sign_in_screen_user_not_found_message}...',
        );
        break;
      case SignInError.wrongPassword:
        await showMessageDialog(
          context: context,
          title:
              AppLocalizations.of(context)!.sign_in_screen_wrong_password_title,
          message: AppLocalizations.of(context)!
              .sign_in_screen_wrong_password_message,
        );
        break;
    }
  }
}
