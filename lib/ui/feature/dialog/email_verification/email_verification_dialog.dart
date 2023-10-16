import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/gap/gap_components.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../component/text/body_text_components.dart';
import '../../../component/text/title_text_components.dart';
import '../../../config/navigation/router.dart';
import '../../../cubit/email_verification_cubit.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';

class EmailVerificationDialog extends StatelessWidget {
  const EmailVerificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailVerificationCubit()..initialize(),
      child: BlocListener<EmailVerificationCubit, EmailVerificationState>(
        listener: _manageCubitState,
        child: const ResponsiveLayout(
          mobileBody: _MobileDialog(),
          desktopBody: _DesktopDialog(),
        ),
      ),
    );
  }

  Future<void> _manageCubitState(
    BuildContext context,
    EmailVerificationState state,
  ) async {
    if (state is EmailVerificationStateTooManyRequests) {
      await showMessageDialog(
        title: Str.of(context).tooManyRequestsDialogTitle,
        message: Str.of(context).tooManyRequestsDialogMessage,
      );
    }
  }
}

class _MobileDialog extends StatelessWidget {
  const _MobileDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(onPressed: popUntilRoot),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.outlineVariant,
          size: 120,
        ),
        const Gap40(),
        TitleLarge(
          str.emailVerificationTitle,
          fontWeight: FontWeight.bold,
        ),
        const Gap16(),
        BodyMedium(
          str.emailVerificationMessage,
          textAlign: TextAlign.center,
        ),
        const Gap16(),
        const _Email(),
        const Gap16(),
        BodyMedium(
          str.emailVerificationInstruction,
          textAlign: TextAlign.center,
        ),
        const Gap40(),
        const _ResendEmailVerificationButton(),
        const Gap16(),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              popRoute();
              navigateAndRemoveUntil(const SignInRoute());
            },
            child: BodyMedium(
              str.emailVerificationBackToLogin,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (EmailVerificationCubit cubit) => cubit.state.email,
    );

    return BodyLarge(email ?? '--', fontWeight: FontWeight.bold);
  }
}

class _ResendEmailVerificationButton extends StatelessWidget {
  const _ResendEmailVerificationButton();

  @override
  Widget build(BuildContext context) {
    final cubitState = context.select(
      (EmailVerificationCubit cubit) => cubit.state,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: FilledButton(
          onPressed: cubitState is EmailVerificationStateLoading
              ? null
              : () => _onPressed(context),
          child: cubitState is EmailVerificationStateLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                )
              : Text(Str.of(context).emailVerificationResend),
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await context.read<EmailVerificationCubit>().resendEmailVerification();
  }
}
