import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../service/navigator_service.dart';

class FullScreenDialog extends StatelessWidget {
  final String title;
  final String? submitButtonLabel;
  final bool isSubmitButtonDisabled;
  final Widget body;
  final VoidCallback? onSubmitButtonPressed;

  const FullScreenDialog({
    super.key,
    required this.title,
    this.submitButtonLabel,
    this.isSubmitButtonDisabled = false,
    required this.body,
    this.onSubmitButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: const IconButton(
          onPressed: navigateBack,
          icon: Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: isSubmitButtonDisabled ? null : onSubmitButtonPressed,
            child: Text(
              submitButtonLabel ?? Str.of(context).save,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: body,
    );
  }
}
