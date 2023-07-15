import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service/navigator_service.dart';
import '../text/label_text_components.dart';

class ConfirmationDialogComponent extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmButtonLabel;
  final String? cancelButtonLabel;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;

  const ConfirmationDialogComponent({
    super.key,
    required this.title,
    required this.message,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
    this.confirmButtonColor,
    this.cancelButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => popRoute(result: false),
          child: LabelMedium(
            cancelButtonLabel ?? Str.of(context).cancel,
            color: cancelButtonColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        TextButton(
          onPressed: () => popRoute(result: true),
          child: LabelMedium(
            confirmButtonLabel ?? Str.of(context).confirm,
            color: confirmButtonColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
