import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/date_of_birth_picker_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/label_text_components.dart';
import '../../cubit/profile/identities/profile_identities_cubit.dart';
import '../../service/navigator_service.dart';

class ProfileDateOfBirthDialog extends StatefulWidget {
  const ProfileDateOfBirthDialog({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileDateOfBirthDialog> {
  late final DateTime? _originalDateOfBirth;
  DateTime? _dateOfBirth;
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _originalDateOfBirth =
        context.read<ProfileIdentitiesCubit>().state.dateOfBirth;
    _dateOfBirth = _originalDateOfBirth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _FullScreenDialog(
        initialDateOfBirth: _dateOfBirth,
        isSaveButtonDisabled: _isSaveButtonDisabled,
        onDatePicked: _onDatePicked,
        onSave: _onSave,
      ),
      desktopBody: _NormalDialog(
        initialDateOfBirth: _dateOfBirth,
        isSaveButtonDisabled: _isSaveButtonDisabled,
        onDatePicked: _onDatePicked,
        onSave: _onSave,
      ),
    );
  }

  void _onDatePicked(DateTime dateOfBirth) {
    setState(() {
      _dateOfBirth = dateOfBirth;
      _isSaveButtonDisabled = dateOfBirth == _originalDateOfBirth;
    });
  }

  void _onSave() {
    popRoute(result: _dateOfBirth);
  }
}

class _NormalDialog extends StatelessWidget {
  final DateTime? initialDateOfBirth;
  final bool isSaveButtonDisabled;
  final Function(DateTime) onDatePicked;
  final VoidCallback onSave;

  const _NormalDialog({
    required this.initialDateOfBirth,
    required this.isSaveButtonDisabled,
    required this.onDatePicked,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Str.of(context).profileChangeEmailDialogTitle),
      content: SizedBox(
        width: 400,
        child: DateOfBirthPicker(
          initialDateOfBirth: initialDateOfBirth,
          onDatePicked: onDatePicked,
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: LabelLarge(
            Str.of(context).cancel,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FilledButton(
          onPressed: isSaveButtonDisabled ? null : onSave,
          child: Text(Str.of(context).save),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  final DateTime? initialDateOfBirth;
  final bool isSaveButtonDisabled;
  final Function(DateTime) onDatePicked;
  final VoidCallback onSave;

  const _FullScreenDialog({
    required this.initialDateOfBirth,
    required this.isSaveButtonDisabled,
    required this.onDatePicked,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          onPressed: popRoute,
          icon: Icon(Icons.close),
        ),
        title: Text(Str.of(context).profileChangeDateOfBirthDialogTitle),
        actions: [
          FilledButton(
            onPressed: isSaveButtonDisabled ? null : onSave,
            child: Text(Str.of(context).save),
          ),
          const GapHorizontal16(),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Colors.transparent,
          child: Column(
            children: [
              DateOfBirthPicker(
                initialDateOfBirth: initialDateOfBirth,
                onDatePicked: onDatePicked,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
