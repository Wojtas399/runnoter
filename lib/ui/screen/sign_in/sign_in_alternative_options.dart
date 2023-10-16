import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/body_text_components.dart';
import '../../config/navigation/router.dart';
import '../../cubit/sign_in/sign_in_cubit.dart';
import '../../service/navigator_service.dart';

class SignInAlternativeOptions extends StatelessWidget {
  const SignInAlternativeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = Gap24();

    return const Column(
      children: [
        gap,
        _Separator(),
        gap,
        _SocialSignIn(),
        gap,
        _SignUpOption(),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    const textMargin = GapHorizontal24();

    return Row(
      children: [
        const Expanded(child: Divider()),
        textMargin,
        BodyMedium(
          Str.of(context).signInSignInWith,
          color: Theme.of(context).colorScheme.outline,
        ),
        textMargin,
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SocialSignIn extends StatelessWidget {
  const _SocialSignIn();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _SignInWithGoogle(),
          ),
          GapHorizontal16(),
          Expanded(
            child: _SignInWithFacebook(),
          ),
        ],
      ),
    );
  }
}

class _SignInWithGoogle extends StatelessWidget {
  const _SignInWithGoogle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: context.read<SignInCubit>().signInWithGoogle,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset('assets/google_icon.svg'),
        ),
      ),
    );
  }
}

class _SignInWithFacebook extends StatelessWidget {
  const _SignInWithFacebook();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: context.read<SignInCubit>().signInWithFacebook,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset('assets/facebook_icon.svg'),
        ),
      ),
    );
  }
}

class _SignUpOption extends StatelessWidget {
  const _SignUpOption();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onSignUpOptionSelected,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(str.signInDontHaveAccount),
            const SizedBox(width: 4),
            BodyMedium(
              str.signInSignUp,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  void _onSignUpOptionSelected() {
    navigateTo(const SignUpRoute());
  }
}