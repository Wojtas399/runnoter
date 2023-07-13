import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/additional_model/bloc_state.dart';
import '../../domain/additional_model/bloc_status.dart';
import '../config/navigation/router.dart';
import '../service/dialog_service.dart';
import '../service/navigator_service.dart';

class BlocWithStatusListener<Bloc extends StateStreamable<State>,
    State extends BlocState, Info, Error> extends StatelessWidget {
  final Widget child;
  final void Function(State state)? onStateChanged;
  final void Function(Info info)? onInfo;
  final void Function(Error error)? onError;

  const BlocWithStatusListener({
    super.key,
    required this.child,
    this.onStateChanged,
    this.onInfo,
    this.onError,
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
      showLoadingDialog();
    } else if (blocStatus is BlocStatusComplete) {
      closeLoadingDialog();
      _manageCompleteStatus(blocStatus, context);
    } else if (blocStatus is BlocStatusError) {
      closeLoadingDialog();
      _manageErrorStatus(blocStatus, context);
    } else if (blocStatus is BlocStatusUnknownError) {
      closeLoadingDialog();
      _showUnknownErrorMessage(context);
    } else if (blocStatus is BlocStatusNetworkRequestFailed) {
      closeLoadingDialog();
      _showNoInternetConnectionMessage(context);
    } else if (blocStatus is BlocStatusNoLoggedUser) {
      closeLoadingDialog();
      _showNoLoggedUserMessage(context);
      navigateAndRemoveUntil(const SignInRoute());
    }
  }

  void _manageCompleteStatus(
    BlocStatusComplete completeStatus,
    BuildContext context,
  ) {
    final Info? info = completeStatus.info;
    final Function(Info info)? onInfo = this.onInfo;
    if (info != null && onInfo != null) {
      onInfo(info);
    }
  }

  void _manageErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    final Error? error = errorStatus.error;
    final Function(Error error)? onError = this.onError;
    if (error != null && onError != null) {
      onError(error);
    }
  }

  void _showUnknownErrorMessage(BuildContext context) => showMessageDialog(
        title: Str.of(context).unknownErrorDialogTitle,
        message: Str.of(context).unknownErrorDialogMessage,
      );

  void _showNoInternetConnectionMessage(BuildContext context) =>
      showMessageDialog(
        title: Str.of(context).noInternetConnectionDialogTitle,
        message: Str.of(context).noInternetConnectionDialogMessage,
      );

  void _showNoLoggedUserMessage(BuildContext context) => showMessageDialog(
        title: Str.of(context).noLoggedUserDialogTitle,
        message: Str.of(context).noLoggedUserDialogMessage,
      );
}
