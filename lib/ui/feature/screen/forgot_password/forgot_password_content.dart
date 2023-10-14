import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cubit/forgot_password_cubit.dart';
import '../../../component/app_bar_with_logo.dart';
import '../../../component/big_button_component.dart';
import '../../../component/body/small_body_component.dart';
import '../../../component/form_text_field_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../component/text/headline_text_components.dart';
import '../../../service/utils.dart';

class ForgotPasswordContent extends StatelessWidget {
  const ForgotPasswordContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithLogo(),
      body: SafeArea(
        child: SmallBody(
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
    return FormTextField(
      isRequired: true,
      label: Str.of(context).email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      icon: Icons.email,
      onChanged: context.read<ForgotPasswordCubit>().emailChanged,
      onTapOutside: (_) => unfocusInputs(),
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onSubmitted(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    if (!cubit.state.isSubmitButtonDisabled) cubit.submit();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ForgotPasswordCubit cubit) => cubit.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).forgotPasswordSubmitButtonLabel,
      isDisabled: isDisabled,
      onPressed: context.read<ForgotPasswordCubit>().submit,
    );
  }
}
