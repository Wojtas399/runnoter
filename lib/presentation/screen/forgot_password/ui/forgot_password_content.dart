import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/big_button_component.dart';
import '../../../component/text_field_component.dart';
import '../../../service/utils.dart';
import 'forgot_password_app_bar.dart';

class ForgotPasswordContent extends StatelessWidget {
  const ForgotPasswordContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ForgotPasswordAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  _Header(),
                  SizedBox(height: 32),
                  _Email(),
                  SizedBox(height: 32),
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
        Text(
          AppLocalizations.of(context)!.forgot_password_message_title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.forgot_password_message_text,
        )
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
      label: AppLocalizations.of(context)!.email,
      icon: Icons.email,
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: AppLocalizations.of(context)!.forgot_password_submit_button_label,
      onPressed: () {},
    );
  }
}
