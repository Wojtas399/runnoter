import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service/navigator_service.dart';

class ConfirmationDialogComponent extends StatelessWidget {
  final String title;
  final String message;
  final String? cancelButtonLabel;
  final String? confirmButtonLabel;

  const ConfirmationDialogComponent({
    super.key,
    required this.title,
    required this.message,
    this.cancelButtonLabel,
    this.confirmButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            navigateBack(
              context: context,
              result: false,
            );
          },
          child: Text(
            cancelButtonLabel ?? AppLocalizations.of(context)!.cancel,
          ),
        ),
        TextButton(
          onPressed: () {
            navigateBack(
              context: context,
              result: true,
            );
          },
          child: Text(
            confirmButtonLabel ?? AppLocalizations.of(context)!.confirm,
          ),
        ),
      ],
    );
  }
}
