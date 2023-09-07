import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/sign_in/sign_in_cubit.dart';
import '../../component/big_button_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/password_text_field_component.dart';
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
        Gap24(),
        _Password(),
        Gap32(),
        _SubmitButton(),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        label: Text(Str.of(context).email),
        prefixIcon: const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onChanged: context.read<SignInCubit>().emailChanged,
      onTapOutside: (_) => unfocusInputs(),
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onSubmitted(BuildContext context) {
    final SignInCubit cubit = context.read<SignInCubit>();
    if (!cubit.state.isButtonDisabled) cubit.submit();
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
          onChanged: context.read<SignInCubit>().passwordChanged,
          onSubmitted: (_) => _onSubmitted(context),
        ),
        const Gap8(),
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

  void _onSubmitted(BuildContext context) {
    final SignInCubit cubit = context.read<SignInCubit>();
    if (!cubit.state.isButtonDisabled) cubit.submit();
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
      (SignInCubit bloc) => bloc.state.isButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).signInButtonLabel,
      isDisabled: isButtonDisabled,
      onPressed: context.read<SignInCubit>().submit,
    );
  }
}
