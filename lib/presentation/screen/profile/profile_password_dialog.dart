import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../component/password_text_field_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/label_text_components.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../../service/validation_service.dart';

class ProfilePasswordDialog extends StatefulWidget {
  const ProfilePasswordDialog({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfilePasswordDialog> {
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _newPasswordController.addListener(_checkPasswordsCorrectness);
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_checkPasswordsCorrectness);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileIdentitiesBloc, ProfileIdentitiesState>(
      listener: (BuildContext context, ProfileIdentitiesState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusComplete &&
            blocStatus.info == ProfileIdentitiesBlocInfo.dataSaved) {
          popRoute();
        }
      },
      child: ResponsiveLayout(
        mobileBody: _FullScreenDialog(
          newPasswordController: _newPasswordController,
          isSaveButtonDisabled: _isSaveButtonDisabled,
          newPasswordValidator: _validatePassword,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
        ),
        desktopBody: _NormalDialog(
          newPasswordController: _newPasswordController,
          isSaveButtonDisabled: _isSaveButtonDisabled,
          newPasswordValidator: _validatePassword,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
        ),
      ),
    );
  }

  void _checkPasswordsCorrectness() {
    final String newPassword = _newPasswordController.text;
    setState(() {
      _isSaveButtonDisabled =
          newPassword.isEmpty || !isPasswordValid(newPassword);
    });
  }

  String? _validatePassword(String? value) {
    return value != null && !isPasswordValid(value)
        ? Str.of(context).invalidPasswordMessage
        : null;
  }

  Future<void> _onSaveButtonPressed(BuildContext context) async {
    unfocusInputs();
    final bloc = context.read<ProfileIdentitiesBloc>();
    final bool reauthenticated = await askForReauthentication();
    if (reauthenticated) {
      bloc.add(
        ProfileIdentitiesEventUpdatePassword(
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }
}

class _NormalDialog extends StatelessWidget {
  final TextEditingController newPasswordController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) newPasswordValidator;
  final VoidCallback onSaveButtonPressed;

  const _NormalDialog({
    required this.newPasswordController,
    required this.isSaveButtonDisabled,
    required this.newPasswordValidator,
    required this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.profileNewPasswordDialogTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PasswordTextFieldComponent(
              label: str.profileNewPasswordDialogNewPassword,
              isRequired: true,
              controller: newPasswordController,
              validator: newPasswordValidator,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: LabelLarge(
            str.cancel,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FilledButton(
          onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
          child: Text(str.save),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  final TextEditingController newPasswordController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) newPasswordValidator;
  final VoidCallback onSaveButtonPressed;

  const _FullScreenDialog({
    required this.newPasswordController,
    required this.isSaveButtonDisabled,
    required this.newPasswordValidator,
    required this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(str.profileNewPasswordDialogTitle),
        leading: const CloseButton(),
        actions: [
          FilledButton(
            onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
            child: Text(str.save),
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
                PasswordTextFieldComponent(
                  label: str.profileNewPasswordDialogNewPassword,
                  isRequired: true,
                  controller: newPasswordController,
                  validator: newPasswordValidator,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
