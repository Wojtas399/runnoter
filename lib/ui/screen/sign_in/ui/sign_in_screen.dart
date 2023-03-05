import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:runnoter/auth/auth.dart';
import 'package:runnoter/ui/component/big_button_component.dart';
import 'package:runnoter/ui/component/bloc_with_status_listener_component.dart';
import 'package:runnoter/ui/component/password_text_field_component.dart';
import 'package:runnoter/ui/component/text_field_component.dart';
import 'package:runnoter/ui/screen/sign_in/bloc/sign_in_bloc.dart';
import 'package:runnoter/ui/service/utils.dart';

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
        auth: context.read<Auth>(),
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
    );
  }
}
