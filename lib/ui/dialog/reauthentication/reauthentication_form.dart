import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/body_text_components.dart';
import '../../cubit/reauthentication/reauthentication_cubit.dart';
import '../../model/cubit_status.dart';
import 'reauthentication_password.dart';

class ReauthenticationForm extends StatelessWidget {
  const ReauthenticationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const Widget gap = Gap24();

    return Column(
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
        const GapHorizontal16(),
        BodyMedium(
          Str.of(context).reauthenticationOrUse,
          color: Theme.of(context).colorScheme.outline,
        ),
        const GapHorizontal16(),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleAuthentication extends StatelessWidget {
  const _GoogleAuthentication();

  @override
  Widget build(BuildContext context) {
    final CubitStatus cubitStatus = context.select(
      (ReauthenticationCubit cubit) => cubit.state.status,
    );

    return _SocialAuthenticationButton(
      svgIconPath: 'assets/google_icon.svg',
      isLoading: cubitStatus is CubitStatusLoading &&
          cubitStatus.loadingInfo ==
              ReauthenticationCubitLoadingInfo.googleReauthenticationLoading,
      isDisabled: cubitStatus is CubitStatusLoading,
      onPressed: context.read<ReauthenticationCubit>().useGoogle,
    );
  }
}

class _FacebookAuthentication extends StatelessWidget {
  const _FacebookAuthentication();

  @override
  Widget build(BuildContext context) {
    final CubitStatus cubitStatus = context.select(
      (ReauthenticationCubit cubit) => cubit.state.status,
    );

    return _SocialAuthenticationButton(
      svgIconPath: 'assets/facebook_icon.svg',
      isLoading: cubitStatus is CubitStatusLoading &&
          cubitStatus.loadingInfo ==
              ReauthenticationCubitLoadingInfo.facebookReauthenticationLoading,
      isDisabled: cubitStatus is CubitStatusLoading,
      onPressed: context.read<ReauthenticationCubit>().useFacebook,
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
