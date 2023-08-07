import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/forgot_password/forgot_password_bloc.dart';
import '../../component/app_bar_with_logo.dart';
import '../../component/big_button_component.dart';
import '../../component/body/small_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/headline_text_components.dart';
import '../../component/text_field_component.dart';
import '../../service/utils.dart';

class ForgotPasswordContent extends StatelessWidget {
  const ForgotPasswordContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithLogo(),
      body: SafeArea(
        child: GestureDetector(
          onTap: unfocusInputs,
          child: const SmallBody(
            child: Paddings24(
              child: Column(
                children: [
                  _Header(),
                  Gap32(),
                  _Email(),
                  Gap32(),
                  _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadlineMedium(
          Str.of(context).forgotPasswordTitle,
          fontWeight: FontWeight.bold,
        ),
        const Gap8(),
        Text(Str.of(context).forgotPasswordMessage)
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      isRequired: true,
      label: Str.of(context).email,
      icon: Icons.email,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<ForgotPasswordBloc>().add(
          ForgotPasswordEventEmailChanged(email: value ?? ''),
        );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ForgotPasswordBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).forgotPasswordSubmitButtonLabel,
      isDisabled: isDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<ForgotPasswordBloc>().add(
          const ForgotPasswordEventSubmit(),
        );
  }
}
