import 'package:flutter/material.dart';
import 'package:runnoter/ui/component/loading_dialog_component.dart';

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
