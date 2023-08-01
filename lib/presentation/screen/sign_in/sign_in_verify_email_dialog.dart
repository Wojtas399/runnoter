import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/sign_in/sign_in_bloc.dart';
import '../../component/big_button_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../service/navigator_service.dart';

class SignInVerifyEmailDialog extends StatelessWidget {
  const SignInVerifyEmailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: _MobileDialog(),
      desktopBody: _DesktopDialog(),
    );
  }
}

class _MobileDialog extends StatelessWidget {
  const _MobileDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: const SafeArea(
        child: Paddings24(
          child: _EmailVerificationInfo(),
        ),
      ),
    );
  }
}

class _DesktopDialog extends StatelessWidget {
  const _DesktopDialog();

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: _EmailVerificationInfo(),
      ),
    );
  }
}

class _EmailVerificationInfo extends StatelessWidget {
  const _EmailVerificationInfo();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const gapSmall = SizedBox(height: 16);
    const gapBig = SizedBox(height: 40);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.outlineVariant,
          size: 120,
        ),
        gapBig,
        TitleLarge(
          str.signInUnverifiedEmailDialogTitle,
          fontWeight: FontWeight.bold,
        ),
        gapSmall,
        BodyMedium(
          str.signInUnverifiedEmailDialogMessage,
          textAlign: TextAlign.center,
        ),
        gapSmall,
        const _Email(),
        gapSmall,
        BodyMedium(
          str.signInUnverifiedEmailDialogInstruction,
          textAlign: TextAlign.center,
        ),
        gapBig,
        BigButton(
          label: str.signInUnverifiedEmailDialogResend,
          onPressed: () => _onResendPressed(context),
        ),
        gapSmall,
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: popRoute,
            child: BodyMedium(
              str.signInUnverifiedEmailDialogBackToLogin,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }

  void _onResendPressed(BuildContext context) {
    //TODO: Call sign in bloc's event to resend email
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select((SignInBloc bloc) => bloc.state.email);

    return BodyLarge(email ?? '--', fontWeight: FontWeight.bold);
  }
}
