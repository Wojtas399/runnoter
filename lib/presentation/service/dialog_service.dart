import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../component/action_sheet_component.dart';
import '../component/dialog/confirmation_dialog_component.dart';
import '../component/dialog/loading_dialog_component.dart';
import '../component/dialog/message_dialog_component.dart';
import '../component/dialog/value_dialog_component.dart';
import '../config/animation/slide_to_top_anim.dart';
import '../extension/context_extensions.dart';
import 'navigator_service.dart';

bool _isLoadingDialogOpened = false;

void showLoadingDialog() {
  if (navigatorKey.currentContext != null) {
    _isLoadingDialogOpened = true;
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => const LoadingDialog(),
      barrierDismissible: false,
    );
  }
}

void closeLoadingDialog() {
  if (_isLoadingDialogOpened && navigatorKey.currentContext != null) {
    Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();
    _isLoadingDialogOpened = false;
  }
}

Future<void> showMessageDialog({
  required String title,
  required String message,
  String? closeButtonLabel,
}) async {
  await showAlertDialog(
    MessageDialogComponent(
      title: title,
      message: message,
      closeButtonLabel: closeButtonLabel,
    ),
  );
}

void showSnackbarMessage(String message) {
  if (navigatorKey.currentContext != null) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

void hideSnackbar() {
  if (navigatorKey.currentContext != null) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
  }
}

Future<bool> askForConfirmation({
  required String title,
  required String message,
  String? confirmButtonLabel,
  String? cancelButtonLabel,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
}) async =>
    await showAlertDialog(
      ConfirmationDialogComponent(
        title: title,
        message: message,
        confirmButtonLabel: confirmButtonLabel,
        cancelButtonLabel: cancelButtonLabel,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
      ),
    ) ==
    true;

Future<bool> askForConfirmationToLeave({
  bool areUnsavedChanges = false,
}) async {
  if (navigatorKey.currentContext != null) {
    final str = Str.of(navigatorKey.currentContext!);
    return await askForConfirmation(
      title: str.leavePageConfirmationDialogTitle,
      message: switch (areUnsavedChanges) {
        true => str.leavePageWithUnsavedChangesConfirmationDialogMessage,
        false => str.leavePageConfirmationDialogMessage,
      },
      confirmButtonLabel: str.leave,
    );
  }
  return false;
}

Future<String?> askForValue({
  required String title,
  String? label,
  IconData? textFieldIcon,
  String? value,
  bool isValueRequired = false,
  String? Function(String? value)? validator,
}) async {
  hideSnackbar();
  return await showDialogDependingOnScreenSize(
    ValueDialogComponent(
      title: title,
      label: label,
      textFieldIcon: textFieldIcon,
      initialValue: value,
      isValueRequired: isValueRequired,
      validator: validator,
    ),
  );
}

Future<T?> askForAction<T>({
  required List<ActionSheetItem<T>> actions,
  String? title,
}) async {
  if (navigatorKey.currentContext == null) return null;
  hideSnackbar();
  return await showModalBottomSheet(
    context: navigatorKey.currentContext!,
    showDragHandle: true,
    builder: (_) => ActionSheetComponent(
      actions: actions,
      title: title,
    ),
  );
}

Future<DateTime?> askForDate({
  DateTime? initialDate,
  DateTime? lastDate,
}) async {
  if (navigatorKey.currentContext == null) return null;
  return await showDatePicker(
    context: navigatorKey.currentContext!,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: lastDate ?? DateTime(2099, 12, 31),
  );
}

Future<T?> showDialogDependingOnScreenSize<T>(Widget dialog) async {
  if (navigatorKey.currentContext == null) return null;
  return await (navigatorKey.currentContext!.isMobileSize
      ? showFullScreenDialog(dialog)
      : showAlertDialog(dialog));
}

Future<T?> showAlertDialog<T>(Widget dialog) async {
  if (navigatorKey.currentContext == null) return null;
  return await showGeneralDialog<T>(
    context: navigatorKey.currentContext!,
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

Future<T?> showFullScreenDialog<T>(Widget dialog) async {
  if (navigatorKey.currentContext == null) return null;
  return await showGeneralDialog<T?>(
    context: navigatorKey.currentContext!,
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
