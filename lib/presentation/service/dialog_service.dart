import 'package:flutter/material.dart';

import '../component/dialog/loading_dialog_component.dart';
import '../component/dialog/message_dialog_component.dart';

bool _isLoadingDialogOpened = false;

void showLoadingDialog({
  required BuildContext context,
}) {
  _isLoadingDialogOpened = true;
  showDialog(
    context: context,
    builder: (_) => const LoadingDialog(),
  );
}

void closeLoadingDialog({
  required BuildContext context,
}) {
  if (_isLoadingDialogOpened) {
    Navigator.of(context, rootNavigator: true).pop();
    _isLoadingDialogOpened = false;
  }
}

Future<void> showMessageDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? closeButtonLabel,
}) async {
  await showDialog(
    context: context,
    builder: (_) => MessageDialogComponent(
      title: title,
      message: message,
      closeButtonLabel: closeButtonLabel,
    ),
  );
}
