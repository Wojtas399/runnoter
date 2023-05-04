import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/big_button_component.dart';
import '../../../service/utils.dart';
import '../bloc/sign_in_bloc.dart';
import '../bloc/sign_in_event.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).sign_in_screen_button_label,
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
