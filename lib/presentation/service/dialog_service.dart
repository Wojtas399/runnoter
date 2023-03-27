import 'package:flutter/material.dart';

import '../component/dialog/confirmation_dialog_component.dart';
import '../component/dialog/loading_dialog_component.dart';
import '../component/dialog/message_dialog_component.dart';
import '../component/dialog/value_dialog_component.dart';

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

void showSnackbarMessage({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void hideSnackbar({
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

Future<bool> askForConfirmation({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmButtonLabel,
}) async {
  return await showDialog(
        context: context,
        builder: (_) => ConfirmationDialogComponent(
          title: title,
          message: message,
          confirmButtonLabel: confirmButtonLabel,
        ),
      ) ==
      true;
}

Future<String?> askForValue({
  required BuildContext context,
  required String title,
  String? label,
  IconData? textFieldIcon,
  String? value,
  bool isValueRequired = false,
  String? Function(String? value)? validator,
}) async {
  hideSnackbar(context: context);
  return await showDialog<String?>(
    context: context,
    builder: (_) => ValueDialogComponent(
      title: title,
      label: label,
      textFieldIcon: textFieldIcon,
      initialValue: value,
      isValueRequired: isValueRequired,
      validator: validator,
    ),
  );
}
