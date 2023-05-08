import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/navigation/routes.dart';
import '../../../service/navigator_service.dart';

class SignInAlternativeOptions extends StatelessWidget {
  const SignInAlternativeOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _onSignUpOptionSelected(context);
          },
          child: Text(
            Str.of(context).signInSignUpOption,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _onForgotPasswordSelected(context);
          },
          child: Text(
            Str.of(context).signInForgotPasswordOption,
          ),
        ),
      ],
    );
  }

  void _onSignUpOptionSelected(BuildContext context) {
    navigateTo(
      context: context,
      route: const SignUpRoute(),
    );
  }

  void _onForgotPasswordSelected(BuildContext context) {
    navigateTo(
      context: context,
      route: const ForgotPasswordRoute(),
    );
  }
}
