library forgot_password_screen;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:runnoter/presentation/component/big_button_component.dart';
import 'package:runnoter/presentation/component/text_field_component.dart';
import 'package:runnoter/presentation/service/utils.dart';

part 'forgot_password_app_bar.dart';
part 'forgot_password_content.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}
