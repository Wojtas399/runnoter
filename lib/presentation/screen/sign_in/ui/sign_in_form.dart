import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/password_text_field_component.dart';
import '../../../component/text_field_component.dart';
import '../bloc/sign_in_bloc.dart';
import '../bloc/sign_in_event.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _Email(),
        SizedBox(height: 24),
        _Password(),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: AppLocalizations.of(context)!.email,
      icon: Icons.email,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
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
    return PasswordTextFieldComponent(
      onChanged: (String? value) {
        _onChanged(value, context);
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    if (value != null) {
      context.read<SignInBloc>().add(
            SignInEventPasswordChanged(password: value),
          );
    }
  }
}
