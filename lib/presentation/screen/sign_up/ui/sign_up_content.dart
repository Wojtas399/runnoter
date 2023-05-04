import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/app_bar_with_logo.dart';
import '../../../service/utils.dart';
import 'sign_up_alternative_option.dart';
import 'sign_up_form.dart';
import 'sign_up_submit_button.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithLogo(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  _FormHeader(),
                  SizedBox(height: 32),
                  SignUpForm(),
                  SizedBox(height: 32),
                  SignUpSubmitButton(),
                  SizedBox(height: 16),
                  SignUpAlternativeOption(),
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
    return Text(
      Str.of(context).sign_up_screen_title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
