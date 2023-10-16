import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/additional_model/cubit_status.dart';
import '../config/navigation/router.dart';
import '../model/cubit_state.dart';
import '../service/dialog_service.dart';
import '../service/navigator_service.dart';

class CubitWithStatusListener<Cubit extends StateStreamable<State>,
    State extends CubitState, Info, Error> extends StatelessWidget {
  final Widget? child;
  final bool showDialogOnLoading;
  final bool showDialogOnNoInternetConnection;
  final void Function(State state)? onStateChanged;
  final void Function(Info info)? onInfo;
  final void Function(Error error)? onError;

  const CubitWithStatusListener({
    super.key,
    this.child,
    this.showDialogOnLoading = true,
    this.showDialogOnNoInternetConnection = true,
    this.onStateChanged,
    this.onInfo,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<Cubit, State>(
      listener: (BuildContext context, State state) {
        _manageCubitStatus(state.status, context);
        _emitStateChange(state);
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

  void _manageCubitStatus(CubitStatus cubitStatus, BuildContext context) {
    if (cubitStatus is CubitStatusLoading && showDialogOnLoading) {
      showLoadingDialog();
    } else {
      closeLoadingDialog();
      if (cubitStatus is CubitStatusComplete) {
        _manageCompleteStatus(cubitStatus, context);
      } else if (cubitStatus is CubitStatusError) {
        _manageErrorStatus(cubitStatus, context);
      } else if (cubitStatus is CubitStatusUnknownError) {
        _showUnknownErrorMessage(context);
      } else if (cubitStatus is CubitStatusNoInternetConnection) {
        if (showDialogOnNoInternetConnection) showNoInternetConnectionMessage();
      } else if (cubitStatus is CubitStatusNoLoggedUser) {
        _showNoLoggedUserMessage(context);
        navigateAndRemoveUntil(const SignInRoute());
      }
    }
  }

  void _manageCompleteStatus(
    CubitStatusComplete completeStatus,
    BuildContext context,
  ) {
    final Info? info = completeStatus.info;
    final Function(Info info)? onInfo = this.onInfo;
    if (info != null && onInfo != null) {
      onInfo(info);
    }
  }

  void _manageErrorStatus(CubitStatusError errorStatus, BuildContext context) {
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

  void _showNoLoggedUserMessage(BuildContext context) => showMessageDialog(
        title: Str.of(context).noLoggedUserDialogTitle,
        message: Str.of(context).noLoggedUserDialogMessage,
      );
}
