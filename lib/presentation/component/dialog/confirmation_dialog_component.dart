import 'package:flutter/material.dart';

import '../../service/navigator_service.dart';

class ConfirmationDialogComponent extends StatelessWidget {
  final String title;
  final String message;
  final String? cancelButtonLabel;
  final String? acceptButtonLabel;

  const ConfirmationDialogComponent({
    super.key,
    required this.title,
    required this.message,
    this.cancelButtonLabel,
    this.acceptButtonLabel,
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
            cancelButtonLabel ?? 'Anuluj',
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
            acceptButtonLabel ?? 'Zatwierdź',
          ),
        ),
      ],
    );
  }
}
