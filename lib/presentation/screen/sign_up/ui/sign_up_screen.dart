import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/presentation/component/big_button_component.dart';
import 'package:runnoter/presentation/component/bloc_with_status_listener_component.dart';
import 'package:runnoter/presentation/component/password_text_field_component.dart';
import 'package:runnoter/presentation/component/text_field_component.dart';
import 'package:runnoter/presentation/config/navigation/routes.dart';
import 'package:runnoter/presentation/screen/sign_up/bloc/sign_up_bloc.dart';
import 'package:runnoter/presentation/service/dialog_service.dart';
import 'package:runnoter/presentation/service/navigator_service.dart';
import 'package:runnoter/presentation/service/utils.dart';

part 'sign_up_alternative_option.dart';
part 'sign_up_app_bar.dart';
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
      case SignUpError.emailAlreadyTaken:
        await showMessageDialog(
          context: context,
          title: AppLocalizations.of(context)!
              .sign_up_screen_already_taken_email_title,
          message: AppLocalizations.of(context)!
              .sign_up_screen_already_taken_email_message,
        );
        break;
    }
  }
}
