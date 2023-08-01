import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/email_verification/email_verification_cubit.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class EmailVerificationDialog extends StatelessWidget {
  const EmailVerificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailVerificationCubit(),
      child: const ResponsiveLayout(
        mobileBody: _MobileDialog(),
        desktopBody: _DesktopDialog(),
      ),
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
          str.emailVerificationTitle,
          fontWeight: FontWeight.bold,
        ),
        gapSmall,
        BodyMedium(
          str.emailVerificationMessage,
          textAlign: TextAlign.center,
        ),
        gapSmall,
        const _Email(),
        gapSmall,
        BodyMedium(
          str.emailVerificationInstruction,
          textAlign: TextAlign.center,
        ),
        gapBig,
        const _ResendEmailVerificationButton(),
        gapSmall,
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: popRoute,
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
      (EmailVerificationCubit cubit) => cubit.state,
    );

    return BodyLarge(email ?? '--', fontWeight: FontWeight.bold);
  }
}

class _ResendEmailVerificationButton extends StatefulWidget {
  const _ResendEmailVerificationButton();

  @override
  State<StatefulWidget> createState() => _ResendEmailVerificationButtonState();
}

class _ResendEmailVerificationButtonState
    extends State<_ResendEmailVerificationButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: FilledButton(
          onPressed: _onPressed,
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(Str.of(context).emailVerificationResend),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    await context.read<EmailVerificationCubit>().resendEmailVerification();
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      showSnackbarMessage(
        Str.of(context).emailVerificationSuccessfullyResentEmailVerification,
      );
    }
  }
}
