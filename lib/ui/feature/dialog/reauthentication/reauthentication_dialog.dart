import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/cubit_with_status_listener_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/text/title_text_components.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'cubit/reauthentication_cubit.dart';
import 'reauthentication_form.dart';

class ReauthenticationBottomSheet extends StatelessWidget {
  const ReauthenticationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReauthenticationCubit(),
      child: _CubitListener(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    TitleLarge(Str.of(context).reauthenticationTitle),
                    const Gap16(),
                    const ReauthenticationForm(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                width: double.infinity,
                child: TextButton(
                  onPressed: () => popRoute(result: false),
                  child: Text(Str.of(context).cancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReauthenticationDialog extends StatelessWidget {
  const ReauthenticationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReauthenticationCubit(),
      child: _CubitListener(
        child: AlertDialog(
          title: Text(Str.of(context).reauthenticationTitle),
          content: const SizedBox(
            width: 400,
            child: ReauthenticationForm(),
          ),
          actions: [
            TextButton(
              onPressed: () => popRoute(result: false),
              child: Text(Str.of(context).cancel),
            )
          ],
        ),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<ReauthenticationCubit, ReauthenticationState,
        ReauthenticationCubitInfo, ReauthenticationCubitError>(
      showDialogOnLoading: false,
      onInfo: (ReauthenticationCubitInfo info) => _manageInfo(info, context),
      onError: (ReauthenticationCubitError error) =>
          _manageError(error, context),
      child: child,
    );
  }

  void _manageInfo(ReauthenticationCubitInfo info, BuildContext context) {
    switch (info) {
      case ReauthenticationCubitInfo.userConfirmed:
        popRoute(result: true);
        break;
    }
  }

  Future<void> _manageError(
    ReauthenticationCubitError error,
    BuildContext context,
  ) async {
    final str = Str.of(context);
    switch (error) {
      case ReauthenticationCubitError.wrongPassword:
        await showMessageDialog(
          title: str.reauthenticationWrongPasswordDialogTitle,
          message: str.reauthenticationWrongPasswordDialogMessage,
        );
        break;
      case ReauthenticationCubitError.userMismatch:
        await showMessageDialog(
          title: str.userMismatchDialogTitle,
          message: str.userMismatchDialogMessage,
        );
        break;
    }
  }
}
