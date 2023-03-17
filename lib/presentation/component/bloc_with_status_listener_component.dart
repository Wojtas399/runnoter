import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/bloc_state.dart';
import '../model/bloc_status.dart';
import '../service/dialog_service.dart';

class BlocWithStatusListener<Bloc extends StateStreamable<State>,
    State extends BlocState, Info, Error> extends StatelessWidget {
  final Widget child;
  final void Function(State state)? onStateChanged;
  final void Function(Info info)? onCompleteStatusChanged;
  final void Function(Error error)? onErrorStatusChanged;

  const BlocWithStatusListener({
    super.key,
    required this.child,
    this.onStateChanged,
    this.onCompleteStatusChanged,
    this.onErrorStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<Bloc, State>(
      listener: (BuildContext context, State state) {
        _emitStateChange(state);
        _manageBlocStatus(state.status, context);
      },
      child: child,
    );
  }

  void _emitStateChange(State newState) {
    final void Function(State state)? onStateChanged = this.onStateChanged;
    if (onStateChanged != null) {
      onStateChanged(newState);
    }
  }

  void _manageBlocStatus(BlocStatus blocStatus, BuildContext context) {
    if (blocStatus is BlocStatusLoading) {
      showLoadingDialog(context: context);
    } else if (blocStatus is BlocStatusComplete) {
      _closeLoadingDialog(context);
      _manageCompleteStatus(blocStatus, context);
    } else if (blocStatus is BlocStatusError) {
      _closeLoadingDialog(context);
      _manageErrorStatus(blocStatus, context);
    } else if (blocStatus is BlocStatusUnknownError) {
      closeLoadingDialog(context: context);
      _showUnknownErrorMessage(context);
    } else if (blocStatus is BlocStatusNoInternetConnection) {
      closeLoadingDialog(context: context);
      _showNoInternetConnectionMessage(context);
    }
  }

  void _manageCompleteStatus(
    BlocStatusComplete completeStatus,
    BuildContext context,
  ) {
    final Info? info = completeStatus.info;
    final Function(Info info)? onCompleteStatusChanged =
        this.onCompleteStatusChanged;
    if (info != null && onCompleteStatusChanged != null) {
      onCompleteStatusChanged(info);
    }
  }

  void _manageErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    final Error? error = errorStatus.error;
    final Function(Error error)? onErrorStatusChanged =
        this.onErrorStatusChanged;
    if (error != null && onErrorStatusChanged != null) {
      onErrorStatusChanged(error);
    }
  }

  void _showUnknownErrorMessage(BuildContext context) {
    showMessageDialog(
      context: context,
      title: AppLocalizations.of(context)!.unknown_error_dialog_title,
      message: AppLocalizations.of(context)!.unknown_error_dialog_message,
    );
  }

  void _showNoInternetConnectionMessage(BuildContext context) {
    showMessageDialog(
      context: context,
      title: AppLocalizations.of(context)!.no_internet_connection_dialog_title,
      message:
          AppLocalizations.of(context)!.no_internet_connection_dialog_message,
    );
  }

  void _closeLoadingDialog(BuildContext context) {
    closeLoadingDialog(context: context);
  }
}
