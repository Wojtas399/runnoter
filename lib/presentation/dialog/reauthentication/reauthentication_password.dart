import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/reauthentication/reauthentication_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/password_text_field_component.dart';
import '../../service/utils.dart';

class ReauthenticationPassword extends StatelessWidget {
  const ReauthenticationPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = context.select(
      (ReauthenticationBloc bloc) =>
          bloc.state.password != null &&
          bloc.state.password?.isNotEmpty == true &&
          bloc.state.status is! BlocStatusLoading,
    );

    return Column(
      children: [
        PasswordTextFieldComponent(
          onChanged: (String? password) =>
              _onPasswordChanged(context, password),
          onTapOutside: (_) => unfocusInputs(),
          onSubmitted: (_) => canSubmit ? _onSubmit(context) : null,
        ),
        const Gap16(),
        _PasswordSubmitButton(
          onPressed: canSubmit ? () => _onSubmit(context) : null,
        ),
      ],
    );
  }

  void _onPasswordChanged(BuildContext context, String? password) {
    context.read<ReauthenticationBloc>().add(
          ReauthenticationEventPasswordChanged(password: password),
        );
  }

  void _onSubmit(BuildContext context) {
    context.read<ReauthenticationBloc>().add(
          const ReauthenticationEventUsePassword(),
        );
  }
}

class _PasswordSubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _PasswordSubmitButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (ReauthenticationBloc bloc) => bloc.state.status,
    );

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: FilledButton(
        onPressed: onPressed,
        child: blocStatus is BlocStatusLoading &&
                blocStatus.loadingInfo ==
                    ReauthenticationBlocLoadingInfo
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
