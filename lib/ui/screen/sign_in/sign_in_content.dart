import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/body/small_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/headline_text_components.dart';
import 'sign_in_alternative_options.dart';
import 'sign_in_form.dart';

class SignInContent extends StatelessWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) => SingleChildScrollView(
            child: SmallBody(
              minHeight: constraints.maxHeight,
              child: Paddings24(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png'),
                    const Gap24(),
                    const _FormHeader(),
                    const Gap32(),
                    const SignInForm(),
                    const SignInAlternativeOptions(),
                  ],
                ),
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
    return HeadlineMedium(
      Str.of(context).signInTitle,
      fontWeight: FontWeight.bold,
    );
  }
}
