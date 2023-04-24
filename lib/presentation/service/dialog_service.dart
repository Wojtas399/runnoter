import 'package:flutter/material.dart';

import '../component/dialog/confirmation_dialog_component.dart';
import '../component/dialog/loading_dialog_component.dart';
import '../component/dialog/message_dialog_component.dart';
import '../component/dialog/value_dialog_component.dart';
import '../config/animation/slide_to_top_anim.dart';

bool _isLoadingDialogOpened = false;

void showLoadingDialog({
  required BuildContext context,
}) {
  _isLoadingDialogOpened = true;
  showDialog(
    context: context,
    builder: (_) => const LoadingDialog(),
    barrierDismissible: false,
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
  await showAlertDialog(
    context: context,
    dialog: MessageDialogComponent(
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
  return await showAlertDialog(
        context: context,
        dialog: ConfirmationDialogComponent(
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
  return await showFullScreenDialog<String?>(
    context: context,
    dialog: ValueDialogComponent(
      title: title,
      label: label,
      textFieldIcon: textFieldIcon,
      initialValue: value,
      isValueRequired: isValueRequired,
      validator: validator,
    ),
  );
}

Future<T?> showAlertDialog<T>({
  required BuildContext context,
  required Widget dialog,
}) async {
  return await showGeneralDialog<T>(
    context: context,
    pageBuilder: (_, anim1, anim2) => dialog,
    transitionBuilder: (BuildContext context, anim1, anim2, child) {
      var curve = Curves.easeInOutQuart.transform(anim1.value);
      return Transform.scale(
        scale: curve,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
    barrierDismissible: true,
    barrierLabel: '',
  );
}

Future<T?> showFullScreenDialog<T>({
  required BuildContext context,
  required Widget dialog,
}) async {
  return await showGeneralDialog<T?>(
    context: context,
    barrierColor: Colors.transparent,
    pageBuilder: (_, a1, a2) => Dialog.fullscreen(
      child: dialog,
    ),
    transitionBuilder: (BuildContext context, anim1, anim2, child) {
      return SlideToTopAnim(
        animation: anim1,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}
