import 'package:flutter/material.dart';
import 'package:runnoter/ui/component/big_button_component.dart';
import 'package:runnoter/ui/component/password_text_field_component.dart';
import 'package:runnoter/ui/component/text_field_component.dart';
import 'package:runnoter/ui/config/navigation/routes.dart';
import 'package:runnoter/ui/service/navigator_service.dart';
import 'package:runnoter/ui/service/utils.dart';

part 'sign_up_alternative_option.dart';
part 'sign_up_app_bar.dart';
part 'sign_up_form.dart';
part 'sign_up_submit_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
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
                _SignUpForm(),
                SizedBox(height: 32),
                _SubmitButton(),
                SizedBox(height: 16),
                _AlternativeOption(),
              ],
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
      'Sign up',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
