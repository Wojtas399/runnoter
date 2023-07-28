import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_in/sign_in_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../config/navigation/router.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'sign_in_content.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
      create: (BuildContext context) =>
          SignInBloc()..add(const SignInEventInitialize()),
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
    return BlocWithStatusListener<SignInBloc, SignInState, SignInBlocInfo,
        SignInBlocError>(
      onInfo: _manageCompletionInfo,
      onError: (SignInBlocError error) {
        _manageError(error, context);
      },
      child: child,
    );
  }

  Future<void> _manageCompletionInfo(SignInBlocInfo info) async {
    switch (info) {
      case SignInBlocInfo.signedIn:
        navigateAndRemoveUntil(const HomeRoute());
        break;
    }
  }

  Future<void> _manageError(
    SignInBlocError error,
    BuildContext context,
  ) async {
    final str = Str.of(context);
    switch (error) {
      case SignInBlocError.invalidEmail:
        await showMessageDialog(
          title: str.signInInvalidEmailDialogTitle,
          message: str.signInInvalidEmailDialogMessage,
        );
        break;
      case SignInBlocError.userNotFound:
        await showMessageDialog(
          title: str.signInUserNotFoundDialogTitle,
          message: '${str.signInUserNotFoundDialogMessage}...',
        );
        break;
      case SignInBlocError.wrongPassword:
        await showMessageDialog(
          title: str.signInWrongPasswordDialogTitle,
          message: str.signInWrongPasswordDialogMessage,
        );
        break;
    }
  }
}
