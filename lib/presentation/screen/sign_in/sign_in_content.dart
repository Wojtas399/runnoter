import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_in/sign_in_bloc.dart';
import '../../component/big_button_component.dart';
import '../../component/body/small_body_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/headline_text_components.dart';
import '../../config/navigation/router.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import 'sign_in_form.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: unfocusInputs,
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) => SingleChildScrollView(
              child: SmallBody(
                minHeight: constraints.maxHeight,
                child: const Paddings24(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Logo(),
                      SizedBox(height: 24),
                      _FormHeader(),
                      SizedBox(height: 32),
                      SignInForm(),
                      SizedBox(height: 32),
                      _SubmitButton(),
                      SizedBox(height: 16),
                      _AlternativeOptions(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/logo.png');
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return HeadlineMedium(
      Str.of(context).signInTitle,
      fontWeight: FontWeight.bold,
    );
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

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _onSignUpOptionSelected,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(str.signInDontHaveAccount),
                const SizedBox(width: 4),
                BodyMedium(
                  str.signInSignUp,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _onForgotPasswordSelected,
            child: Text(str.signInForgotPasswordOption),
          ),
        ),
      ],
    );
  }

  void _onSignUpOptionSelected() {
    navigateTo(const SignUpRoute());
  }

  void _onForgotPasswordSelected() {
    navigateTo(const ForgotPasswordRoute());
  }
}
