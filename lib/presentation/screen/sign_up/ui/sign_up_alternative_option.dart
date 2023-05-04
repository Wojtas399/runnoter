import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/navigation/routes.dart';
import '../../../service/navigator_service.dart';

class SignUpAlternativeOption extends StatelessWidget {
  const SignUpAlternativeOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onPressed(context);
      },
      child: Text(
        Str.of(context).sign_up_screen_sign_in_option,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const SignInRoute(),
    );
  }
}
