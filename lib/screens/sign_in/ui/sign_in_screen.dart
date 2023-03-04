import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/big_button.dart';
import '../../../components/password_text_field_component.dart';
import '../../../components/text_field_component.dart';
import '../../../services/utils.dart';
import '../bloc/sign_in_bloc.dart';

part 'sign_in_alternative_options.dart';
part 'sign_in_form.dart';
part 'sign_in_screen_content.dart';
part 'sign_in_submit_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: const _Content(),
      ),
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
      create: (_) => SignInBloc(),
      child: child,
    );
  }
}
