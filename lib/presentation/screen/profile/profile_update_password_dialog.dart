import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../component/password_text_field_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/label_text_components.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../../service/validation_service.dart';

class ProfileUpdatePasswordDialog extends StatefulWidget {
  const ProfileUpdatePasswordDialog({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileUpdatePasswordDialog> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _newPasswordController.addListener(_checkPasswordsCorrectness);
    _currentPasswordController.addListener(_checkPasswordsCorrectness);
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_checkPasswordsCorrectness);
    _currentPasswordController.removeListener(_checkPasswordsCorrectness);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileIdentitiesBloc, ProfileIdentitiesState>(
      listener: (BuildContext context, ProfileIdentitiesState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusComplete &&
            blocStatus.info == ProfileInfo.savedData) {
          popRoute();
        }
      },
      child: ResponsiveLayout(
        mobileBody: _FullScreenDialog(
          newPasswordController: _newPasswordController,
          currentPasswordController: _currentPasswordController,
          isSaveButtonDisabled: _isSaveButtonDisabled,
          newPasswordValidator: _validatePassword,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
        ),
        desktopBody: _NormalDialog(
          newPasswordController: _newPasswordController,
          currentPasswordController: _currentPasswordController,
          isSaveButtonDisabled: _isSaveButtonDisabled,
          newPasswordValidator: _validatePassword,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
        ),
      ),
    );
  }

  void _checkPasswordsCorrectness() {
    final String newPassword = _newPasswordController.text;
    final String currentPassword = _currentPasswordController.text;
    setState(() {
      _isSaveButtonDisabled = newPassword.isEmpty ||
          !isPasswordValid(newPassword) ||
          currentPassword.isEmpty;
    });
  }

  String? _validatePassword(String? value) {
    if (value != null && !isPasswordValid(value)) {
      return Str.of(context).invalidPasswordMessage;
    }
    return null;
  }

  void _onSaveButtonPressed(BuildContext context) {
    unfocusInputs();
    context.read<ProfileIdentitiesBloc>().add(
          ProfileIdentitiesEventUpdatePassword(
            newPassword: _newPasswordController.text,
            currentPassword: _currentPasswordController.text,
          ),
        );
  }
}

class _NormalDialog extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController currentPasswordController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) newPasswordValidator;
  final VoidCallback onSaveButtonPressed;

  const _NormalDialog({
    required this.newPasswordController,
    required this.currentPasswordController,
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
            const SizedBox(height: 32),
            PasswordTextFieldComponent(
              label: str.profileNewPasswordDialogCurrentPassword,
              isRequired: true,
              controller: currentPasswordController,
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
  final TextEditingController currentPasswordController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) newPasswordValidator;
  final VoidCallback onSaveButtonPressed;

  const _FullScreenDialog({
    required this.newPasswordController,
    required this.currentPasswordController,
    required this.isSaveButtonDisabled,
    required this.newPasswordValidator,
    required this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          str.profileNewPasswordDialogTitle,
        ),
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
                const SizedBox(height: 32),
                PasswordTextFieldComponent(
                  label: str.profileNewPasswordDialogCurrentPassword,
                  isRequired: true,
                  controller: currentPasswordController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
