import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_up/sign_up_bloc.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../../domain/service/connectivity_service.dart';
import '../../component/app_bar_with_logo.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/password_text_field_component.dart';
import '../../component/text/headline_text_components.dart';
import '../../component/text_field_component.dart';
import '../../config/navigation/routes.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'sign_up_alternative_option.dart';
part 'sign_up_content.dart';
part 'sign_up_form.dart';
part 'sign_up_submit_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
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
      create: (_) => SignUpBloc(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
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
    return BlocWithStatusListener<SignUpBloc, SignUpState, SignUpBlocInfo,
        SignUpBlocError>(
      child: child,
      onInfo: (SignUpBlocInfo info) {
        _manageCompletionInfo(info, context);
      },
      onError: (SignUpBlocError error) {
        _manageError(error, context);
      },
    );
  }

  Future<void> _manageCompletionInfo(
    SignUpBlocInfo info,
    BuildContext context,
  ) async {
    switch (info) {
      case SignUpBlocInfo.signedUp:
        navigateAndRemoveUntil(
          context: context,
          route: const HomeRoute(),
        );
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
          context: context,
          title: Str.of(context).signUpAlreadyTakenEmailDialogTitle,
          message: Str.of(context).signUpAlreadyTakenEmailDialogMessage,
        );
        break;
    }
  }
}
