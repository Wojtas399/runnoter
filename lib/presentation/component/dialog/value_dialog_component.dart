import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../text_field_component.dart';

class ValueDialogComponent extends StatefulWidget {
  final String title;
  final String? label;
  final String? initialValue;
  final bool isValueRequired;

  const ValueDialogComponent({
    super.key,
    required this.title,
    this.label,
    this.initialValue,
    this.isValueRequired = false,
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
    _textController.addListener(_checkValueChange);
  }

  @override
  void dispose() {
    _textController.removeListener(_checkValueChange);
    super.dispose();
  }

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
          title: Text(widget.title),
          actions: [
            TextButton(
              onPressed: _isSaveButtonDisabled
                  ? null
                  : () {
                      _onSaveButtonPressed(context);
                    },
              child: Text(
                AppLocalizations.of(context)!.save,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.transparent,
              child: Column(
                children: [
                  TextFieldComponent(
                    label: widget.label,
                    isRequired: widget.isValueRequired,
                    controller: _textController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSaveButtonPressed(BuildContext context) {
    navigateBack(
      context: context,
      result: _textController.text,
    );
  }

  void _checkValueChange() {
    final String value = _textController.text;
    setState(() {
      _isSaveButtonDisabled = value.isEmpty || value == widget.initialValue;
    });
  }
}
