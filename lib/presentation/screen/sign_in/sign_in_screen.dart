import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_in/sign_in_bloc.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/password_text_field_component.dart';
import '../../component/scrollable_content_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/headline_text_components.dart';
import '../../component/text_field_component.dart';
import '../../config/navigation/routes.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'sign_in_alternative_options.dart';
part 'sign_in_form.dart';
part 'sign_in_screen_content.dart';
part 'sign_in_submit_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: _Content(),
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
      )..add(
          const SignInEventInitialize(),
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
      onInfo: _manageCompletionInfo,
      onError: (SignInError error) {
        _manageError(error, context);
      },
      child: child,
    );
  }

  Future<void> _manageCompletionInfo(SignInInfo info) async {
    switch (info) {
      case SignInInfo.signedIn:
        navigateAndRemoveUntil(
          route: const HomeRoute(),
        );
        break;
    }
  }

  Future<void> _manageError(
    SignInError error,
    BuildContext context,
  ) async {
    final str = Str.of(context);
    switch (error) {
      case SignInError.invalidEmail:
        await showMessageDialog(
          title: str.signInInvalidEmailDialogTitle,
          message: str.signInInvalidEmailDialogMessage,
        );
        break;
      case SignInError.userNotFound:
        await showMessageDialog(
          title: str.signInUserNotFoundDialogTitle,
          message: '${str.signInUserNotFoundDialogMessage}...',
        );
        break;
      case SignInError.wrongPassword:
        await showMessageDialog(
          title: str.signInWrongPasswordDialogTitle,
          message: str.signInWrongPasswordDialogMessage,
        );
        break;
    }
  }
}
