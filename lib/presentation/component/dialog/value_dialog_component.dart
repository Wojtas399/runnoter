import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../text/label_text_components.dart';
import '../text_field_component.dart';

class ValueDialogComponent extends StatefulWidget {
  final DialogMode dialogMode;
  final String title;
  final String? label;
  final IconData? textFieldIcon;
  final String? initialValue;
  final bool isValueRequired;
  final String? Function(String? value)? validator;

  const ValueDialogComponent({
    super.key,
    required this.dialogMode,
    required this.title,
    this.label,
    this.textFieldIcon,
    this.initialValue,
    this.isValueRequired = false,
    this.validator,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ValueDialogComponent> {
  final TextEditingController _textController = TextEditingController();
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.initialValue ?? '';
    _textController.addListener(_checkValueCorrectness);
  }

  @override
  void dispose() {
    _textController.removeListener(_checkValueCorrectness);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => switch (widget.dialogMode) {
        DialogMode.normal => _NormalDialog(
            title: widget.title,
            label: widget.label,
            textFieldIcon: widget.textFieldIcon,
            textController: _textController,
            isValueRequired: widget.isValueRequired,
            isSaveButtonDisabled: _isSaveButtonDisabled,
            validator: widget.validator,
            onSaveButtonPressed: () {
              _onSaveButtonPressed(context);
            },
          ),
        DialogMode.fullScreen => _FullScreenDialog(
            title: widget.title,
            label: widget.label,
            textFieldIcon: widget.textFieldIcon,
            textController: _textController,
            isValueRequired: widget.isValueRequired,
            isSaveButtonDisabled: _isSaveButtonDisabled,
            validator: widget.validator,
            onSaveButtonPressed: () {
              _onSaveButtonPressed(context);
            },
          ),
      };

  void _onSaveButtonPressed(BuildContext context) {
    navigateBack(
      context: context,
      result: _textController.text,
    );
  }

  void _checkValueCorrectness() {
    final String value = _textController.text;
    String? validatorMessage;
    if (widget.validator != null) {
      validatorMessage = widget.validator!(value);
    }
    setState(() {
      _isSaveButtonDisabled = value.isEmpty ||
          value == widget.initialValue ||
          validatorMessage != null;
    });
  }
}

class _NormalDialog extends StatelessWidget {
  final String title;
  final String? label;
  final IconData? textFieldIcon;
  final TextEditingController textController;
  final bool isValueRequired;
  final bool isSaveButtonDisabled;
  final String? Function(String? value)? validator;
  final VoidCallback onSaveButtonPressed;

  const _NormalDialog({
    required this.title,
    required this.label,
    required this.textFieldIcon,
    required this.textController,
    required this.isValueRequired,
    required this.isSaveButtonDisabled,
    required this.validator,
    required this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: GestureDetector(
        onTap: unfocusInputs,
        child: SizedBox(
          width: 400,
          child: TextFieldComponent(
            label: label,
            icon: textFieldIcon,
            isRequired: isValueRequired,
            controller: textController,
            validator: validator,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            navigateBack(context: context);
          },
          child: LabelLarge(
            Str.of(context).cancel,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        TextButton(
          onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
          child: Text(Str.of(context).save),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  final String title;
  final String? label;
  final IconData? textFieldIcon;
  final TextEditingController textController;
  final bool isValueRequired;
  final bool isSaveButtonDisabled;
  final String? Function(String? value)? validator;
  final VoidCallback onSaveButtonPressed;

  const _FullScreenDialog({
    required this.title,
    required this.label,
    required this.textFieldIcon,
    required this.textController,
    required this.isValueRequired,
    required this.isSaveButtonDisabled,
    required this.validator,
    required this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              navigateBack(context: context);
            },
            icon: const Icon(Icons.close),
          ),
          title: Text(title),
          actions: [
            TextButton(
              onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
              child: Text(
                Str.of(context).save,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.transparent,
              child: Column(
                children: [
                  TextFieldComponent(
                    label: label,
                    icon: textFieldIcon,
                    isRequired: isValueRequired,
                    controller: textController,
                    validator: validator,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
