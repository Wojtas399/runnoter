import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../service/utils.dart';
import 'sign_in_alternative_options.dart';
import 'sign_in_app_bar.dart';
import 'sign_in_form.dart';
import 'sign_in_submit_button.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SignInAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                children: const [
                  _Logo(),
                  SizedBox(height: 24),
                  _FormHeader(),
                  SizedBox(height: 32),
                  SignInForm(),
                  SizedBox(height: 32),
                  SignInSubmitButton(),
                  SizedBox(height: 16),
                  SignInAlternativeOptions(),
                ],
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
    return Text(
      Str.of(context).signInScreenTitle,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
