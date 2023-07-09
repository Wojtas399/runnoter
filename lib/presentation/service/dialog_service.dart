import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../component/action_sheet_component.dart';
import '../component/dialog/confirmation_dialog_component.dart';
import '../component/dialog/loading_dialog_component.dart';
import '../component/dialog/message_dialog_component.dart';
import '../component/dialog/value_dialog_component.dart';
import '../config/animation/slide_to_top_anim.dart';
import '../extension/context_extensions.dart';

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
  String? cancelButtonLabel,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
}) async =>
    await showAlertDialog(
      context: context,
      dialog: ConfirmationDialogComponent(
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
  required BuildContext context,
  bool areUnsavedChanges = false,
}) async {
  final str = Str.of(context);
  return await askForConfirmation(
    context: context,
    title: str.leavePageConfirmationDialogTitle,
    message: switch (areUnsavedChanges) {
      true => str.leavePageWithUnsavedChangesConfirmationDialogMessage,
      false => str.leavePageConfirmationDialogMessage,
    },
    confirmButtonLabel: str.leave,
  );
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
  return await showDialogDependingOnScreenSize(
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

Future<T?> askForAction<T>({
  required BuildContext context,
  required List<ActionSheetItem<T>> actions,
  String? title,
}) async {
  hideSnackbar(context: context);
  return await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => ActionSheetComponent(
      actions: actions,
      title: title,
    ),
  );
}

Future<DateTime?> askForDate({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? lastDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: lastDate ?? DateTime(2099, 12, 31),
  );
}

Future<T?> showDialogDependingOnScreenSize<T>({
  required BuildContext context,
  required Widget dialog,
}) async =>
    await (context.isMobileSize
        ? showFullScreenDialog(context: context, dialog: dialog)
        : showAlertDialog(context: context, dialog: dialog));

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
