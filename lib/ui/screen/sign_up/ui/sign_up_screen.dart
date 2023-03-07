import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:runnoter/ui/component/big_button_component.dart';
import 'package:runnoter/ui/component/password_text_field_component.dart';
import 'package:runnoter/ui/component/text_field_component.dart';
import 'package:runnoter/ui/config/navigation/routes.dart';
import 'package:runnoter/ui/screen/sign_up/bloc/sign_up_bloc.dart';
import 'package:runnoter/ui/service/navigator_service.dart';
import 'package:runnoter/ui/service/utils.dart';

part 'sign_up_alternative_option.dart';
part 'sign_up_app_bar.dart';
part 'sign_up_content.dart';
part 'sign_up_form.dart';
part 'sign_up_submit_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _Content(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: child,
    );
  }
}
