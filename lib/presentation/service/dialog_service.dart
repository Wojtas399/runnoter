import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../dependency_injection.dart';
import '../component/dialog/confirmation_dialog_component.dart';
import '../component/dialog/loading_dialog_component.dart';
import '../component/dialog/message_dialog_component.dart';
import '../component/dialog/value_dialog_component.dart';
import '../config/animation/slide_to_top_anim.dart';
import '../config/navigation/router.dart';
import '../dialog/reauthentication/reauthentication_dialog.dart';
import '../extension/context_extensions.dart';

bool _isLoadingDialogOpened = false;

void showLoadingDialog() {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context != null) {
    _isLoadingDialogOpened = true;
    showDialog(
      context: context,
      builder: (_) => const LoadingDialog(),
      barrierDismissible: false,
    );
  }
}

void closeLoadingDialog() {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (_isLoadingDialogOpened && context != null) {
    Navigator.of(context, rootNavigator: true).pop();
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
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

Future<void> showNoInternetConnectionMessage() async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context != null) {
    await showMessageDialog(
      title: Str.of(context).noInternetConnectionDialogTitle,
      message: Str.of(context).noInternetConnectionDialogMessage,
    );
  }
}

void hideSnackbar() {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

Future<bool> askForConfirmation({
  required String title,
  required String message,
  String? confirmButtonLabel,
  String? cancelButtonLabel,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
  bool displaySubmitButtonAsFilled = false,
  bool barrierDismissible = true,
}) async =>
    await showAlertDialog(
      ConfirmationDialogComponent(
        title: title,
        message: message,
        confirmButtonLabel: confirmButtonLabel,
        cancelButtonLabel: cancelButtonLabel,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
        displaySubmitButtonAsFilled: displaySubmitButtonAsFilled,
      ),
      barrierDismissible: barrierDismissible,
    ) ==
    true;

Future<bool> askForConfirmationToLeave({
  bool areUnsavedChanges = false,
}) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context != null) {
    final str = Str.of(context);
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

Future<DateTime?> askForDate({
  DateTime? initialDate,
  DateTime? lastDate,
}) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return null;
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: lastDate ?? DateTime(2099, 12, 31),
  );
}

Future<bool> askForReauthentication() async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return false;
  if (context.isMobileSize) {
    return await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const ReauthenticationBottomSheet(),
          ),
        ) ==
        true;
  }
  return await showDialog(
        context: context,
        builder: (_) => const ReauthenticationDialog(),
      ) ==
      true;
}

Future<T?> showDialogDependingOnScreenSize<T>(
  Widget dialog, {
  bool barrierDismissible = true,
}) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return null;
  return await (context.isMobileSize
      ? showFullScreenDialog(dialog)
      : showAlertDialog(dialog, barrierDismissible: barrierDismissible));
}

Future<T?> showAlertDialog<T>(
  Widget dialog, {
  bool barrierDismissible = true,
}) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return null;
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
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
  );
}

Future<T?> showFullScreenDialog<T>(Widget dialog) async {
  final BuildContext? context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) return null;
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
