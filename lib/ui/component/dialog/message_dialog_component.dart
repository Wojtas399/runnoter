import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageDialogComponent extends StatelessWidget {
  final String title;
  final String message;
  final String? closeButtonLabel;

  const MessageDialogComponent({
    super.key,
    required this.title,
    required this.message,
    this.closeButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            closeButtonLabel ?? AppLocalizations.of(context)!.close,
          ),
        ),
      ],
    );
  }
}
