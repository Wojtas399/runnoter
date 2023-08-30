import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_up/sign_up_bloc.dart';
import '../../component/app_bar_with_logo.dart';
import '../../component/big_button_component.dart';
import '../../component/body/small_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/headline_text_components.dart';
import '../../service/navigator_service.dart';
import 'sign_up_form.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWithLogo(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SmallBody(
            child: Paddings24(
              child: Column(
                children: [
                  _FormHeader(),
                  Gap24(),
                  SignUpForm(),
                  Gap32(),
                  _SubmitButton(),
                  Gap16(),
                  _GoToSignInOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return HeadlineMedium(
      Str.of(context).signUpTitle,
      fontWeight: FontWeight.bold,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (SignUpBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).signUpButtonLabel,
      isDisabled: isDisabled,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<SignUpBloc>().add(
          const SignUpEventSubmit(),
        );
  }
}

class _GoToSignInOption extends StatelessWidget {
  const _GoToSignInOption();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: navigateBack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(str.signUpAlreadyHaveAccount),
            const SizedBox(width: 4),
            BodyMedium(
              str.signUpSignIn,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
