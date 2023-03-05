import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runnoter/model/bloc_state.dart';
import 'package:runnoter/model/bloc_status.dart';

class BlocWithStatusListener<Bloc extends StateStreamable<State>,
    State extends BlocState, Info, Error> extends StatelessWidget {
  final Widget child;
  final void Function(State state)? onStateChanged;
  final void Function(Info info)? onCompletionInfo;
  final void Function(Error error)? onError;

  const BlocWithStatusListener({
    super.key,
    required this.child,
    this.onStateChanged,
    this.onCompletionInfo,
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
      _manageLoadingStatus(context);
    } else if (blocStatus is BlocStatusComplete) {
      _manageCompleteStatus(blocStatus, context);
    } else if (blocStatus is BlocStatusError) {
      _manageErrorStatus(blocStatus, context);
    }
  }

  void _manageLoadingStatus(BuildContext context) {
    // context.showLoadingDialog();
    //TODO
  }

  void _manageCompleteStatus(
    BlocStatusComplete completeStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final Info? info = completeStatus.info;
    final Function(Info info)? onCompletionInfo = this.onCompletionInfo;
    if (info != null && onCompletionInfo != null) {
      onCompletionInfo(info);
    }
  }

  void _manageErrorStatus(
    BlocStatusError errorStatus,
    BuildContext context,
  ) {
    _closeLoadingDialog(context);
    final Error? error = errorStatus.error;
    final Function(Error error)? onError = this.onError;
    if (error != null && onError != null) {
      onError(error);
    }
  }

  void _closeLoadingDialog(BuildContext context) {
    // context.closeLoadingDialog();
    //TODO
  }
}
