import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service/navigator_service.dart';
import '../text/label_text_components.dart';

class ConfirmationDialogComponent extends StatelessWidget {
  final Widget title;
  final Widget content;
  final String? confirmButtonLabel;
  final String? cancelButtonLabel;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool displaySubmitButtonAsFilled;

  const ConfirmationDialogComponent({
    super.key,
    required this.title,
    required this.content,
    this.confirmButtonLabel,
    this.cancelButtonLabel,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.displaySubmitButtonAsFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () => popRoute(result: false),
          child: LabelMedium(
            cancelButtonLabel ?? Str.of(context).cancel,
            color: cancelButtonColor ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        displaySubmitButtonAsFilled
            ? FilledButton(
                onPressed: () => popRoute(result: true),
                style: FilledButton.styleFrom(
                  backgroundColor: confirmButtonColor,
                ),
                child: Text(confirmButtonLabel ?? Str.of(context).confirm),
              )
            : TextButton(
                onPressed: () => popRoute(result: true),
                child: LabelMedium(
                  confirmButtonLabel ?? Str.of(context).confirm,
                  color: confirmButtonColor ??
                      Theme.of(context).colorScheme.primary,
                ),
              ),
      ],
    );
  }
}
