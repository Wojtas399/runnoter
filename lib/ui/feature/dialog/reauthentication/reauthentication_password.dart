import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/additional_model/cubit_status.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/password_text_field_component.dart';
import '../../../cubit/reauthentication/reauthentication_cubit.dart';
import '../../../service/utils.dart';

class ReauthenticationPassword extends StatelessWidget {
  const ReauthenticationPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = context.select(
      (ReauthenticationCubit cubit) =>
          cubit.state.password != null &&
          cubit.state.password?.isNotEmpty == true &&
          cubit.state.status is! CubitStatusLoading,
    );

    return Column(
      children: [
        PasswordTextFieldComponent(
          onChanged: context.read<ReauthenticationCubit>().passwordChanged,
          onTapOutside: (_) => unfocusInputs(),
          onSubmitted: (_) => canSubmit
              ? context.read<ReauthenticationCubit>().usePassword
              : null,
        ),
        const Gap16(),
        _PasswordSubmitButton(
          onPressed: canSubmit
              ? context.read<ReauthenticationCubit>().usePassword
              : null,
        ),
      ],
    );
  }
}

class _PasswordSubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _PasswordSubmitButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final CubitStatus cubitStatus = context.select(
      (ReauthenticationCubit cubit) => cubit.state.status,
    );

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: FilledButton(
        onPressed: onPressed,
        child: cubitStatus is CubitStatusLoading &&
                cubitStatus.loadingInfo ==
                    ReauthenticationCubitLoadingInfo
                        .passwordReauthenticationLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              )
            : Text(Str.of(context).reauthenticationAuthenticate),
      ),
    );
  }
}
