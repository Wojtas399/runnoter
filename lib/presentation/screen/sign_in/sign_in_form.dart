import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_in/sign_in_bloc.dart';
import '../../component/big_button_component.dart';
import '../../component/password_text_field_component.dart';
import '../../component/text_field_component.dart';
import '../../config/navigation/router.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Email(),
        SizedBox(height: 24),
        _Password(),
        SizedBox(height: 32),
        _SubmitButton(),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: Str.of(context).email,
      icon: Icons.email,
      onChanged: (String? value) => _onChanged(value, context),
    );
  }

  void _onChanged(String? value, BuildContext context) {
    if (value != null) {
      context.read<SignInBloc>().add(
            SignInEventEmailChanged(email: value),
          );
    }
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PasswordTextFieldComponent(
          onChanged: (String? value) => _onChanged(value, context),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _onForgotPasswordSelected,
            child: Text(Str.of(context).signInForgotPasswordOption),
          ),
        ),
      ],
    );
  }

  void _onChanged(String? value, BuildContext context) {
    if (value != null) {
      context.read<SignInBloc>().add(
            SignInEventPasswordChanged(password: value),
          );
    }
  }

  void _onForgotPasswordSelected() {
    navigateTo(const ForgotPasswordRoute());
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).signInButtonLabel,
      isDisabled: isButtonDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<SignInBloc>().add(
          const SignInEventSubmit(),
        );
  }
}
