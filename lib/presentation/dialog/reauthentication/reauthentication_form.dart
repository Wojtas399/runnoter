import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/reauthentication/reauthentication_bloc.dart';
import '../../component/gap_components.dart';
import '../../component/text/body_text_components.dart';
import '../../service/utils.dart';
import 'reauthentication_password.dart';

class ReauthenticationForm extends StatelessWidget {
  const ReauthenticationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = Gap24();

    return GestureDetector(
      onTap: unfocusInputs,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(str.reauthenticationMessage),
            gap,
            const ReauthenticationPassword(),
            gap,
            const _Separator(),
            gap,
            const _GoogleAuthentication(),
            gap,
            const _FacebookAuthentication(),
            gap,
          ],
        ),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        const Gap16(),
        BodyMedium(
          Str.of(context).reauthenticationOrUse,
          color: Theme.of(context).colorScheme.outline,
        ),
        const Gap16(),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleAuthentication extends StatelessWidget {
  const _GoogleAuthentication();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (ReauthenticationBloc bloc) => bloc.state.status,
    );

    return _SocialAuthenticationButton(
      svgIconPath: 'assets/google_icon.svg',
      isLoading: blocStatus is BlocStatusLoading &&
          blocStatus.loadingInfo ==
              ReauthenticationBlocLoadingInfo.googleReauthenticationLoading,
      isDisabled: blocStatus is BlocStatusLoading,
      onPressed: () => _authenticateWithGoogle(context),
    );
  }

  void _authenticateWithGoogle(BuildContext context) {
    context.read<ReauthenticationBloc>().add(
          const ReauthenticationEventUseGoogle(),
        );
  }
}

class _FacebookAuthentication extends StatelessWidget {
  const _FacebookAuthentication();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (ReauthenticationBloc bloc) => bloc.state.status,
    );

    return _SocialAuthenticationButton(
      svgIconPath: 'assets/facebook_icon.svg',
      isLoading: blocStatus is BlocStatusLoading &&
          blocStatus.loadingInfo ==
              ReauthenticationBlocLoadingInfo.facebookReauthenticationLoading,
      isDisabled: blocStatus is BlocStatusLoading,
      onPressed: () => _authenticateWithFacebook(context),
    );
  }

  void _authenticateWithFacebook(BuildContext context) {
    context.read<ReauthenticationBloc>().add(
          const ReauthenticationEventUseFacebook(),
        );
  }
}

class _SocialAuthenticationButton extends StatelessWidget {
  final String svgIconPath;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;

  const _SocialAuthenticationButton({
    required this.svgIconPath,
    this.isLoading = false,
    this.isDisabled = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        onPressed: isLoading || isDisabled ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(svgIconPath),
              ),
      ),
    );
  }
}
