import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/reauthentication/reauthentication_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/gap_components.dart';
import '../../component/text/title_text_components.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'reauthentication_form.dart';

class ReauthenticationBottomSheet extends StatelessWidget {
  const ReauthenticationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReauthenticationBloc(),
      child: _BlocListener(
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
      create: (_) => ReauthenticationBloc(),
      child: _BlocListener(
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

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ReauthenticationBloc, ReauthenticationState,
        ReauthenticationBlocInfo, ReauthenticationBlocError>(
      showDialogOnLoading: false,
      onInfo: (ReauthenticationBlocInfo info) => _manageInfo(info, context),
      onError: (ReauthenticationBlocError error) =>
          _manageError(error, context),
      child: child,
    );
  }

  void _manageInfo(ReauthenticationBlocInfo info, BuildContext context) {
    switch (info) {
      case ReauthenticationBlocInfo.userConfirmed:
        popRoute(result: true);
        break;
    }
  }

  Future<void> _manageError(
    ReauthenticationBlocError error,
    BuildContext context,
  ) async {
    final str = Str.of(context);
    switch (error) {
      case ReauthenticationBlocError.wrongPassword:
        await showMessageDialog(
          title: str.reauthenticationWrongPasswordDialogTitle,
          message: str.reauthenticationWrongPasswordDialogMessage,
        );
        break;
      case ReauthenticationBlocError.userMismatch:
        await showMessageDialog(
          title: str.userMismatchDialogTitle,
          message: str.userMismatchDialogMessage,
        );
        break;
    }
  }
}
