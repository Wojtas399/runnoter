import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart' '';

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
    final SignInCubit signInCubit = context.read<SignInCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (!kIsWeb && Platform.isIOS) ...[
            _AlternativeSignInButton(
              svgLogo: SvgPicture.asset('assets/apple_logo.svg'),
              onPressed: signInCubit.signInWithApple,
            ),
            const Gap16(),
          ],
          _AlternativeSignInButton(
            svgLogo: SvgPicture.asset('assets/google_logo.svg'),
            onPressed: signInCubit.signInWithGoogle,
          ),
          const Gap16(),
          _AlternativeSignInButton(
            svgLogo: SvgPicture.asset('assets/facebook_logo.svg'),
            onPressed: signInCubit.signInWithFacebook,
          ),
        ],
      ),
    );
  }
}

class _AlternativeSignInButton extends StatelessWidget {
  final SvgPicture svgLogo;
  final VoidCallback onPressed;

  const _AlternativeSignInButton({
    required this.svgLogo,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 300),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: svgLogo,
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
