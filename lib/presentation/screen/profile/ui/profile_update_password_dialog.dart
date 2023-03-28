import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/password_text_field_component.dart';
import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../../../service/validation_service.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

class ProfileUpdatePasswordDialog extends StatefulWidget {
  const ProfileUpdatePasswordDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
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
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nowe hasło',
          ),
          leading: IconButton(
            onPressed: () {
              navigateBack(context: context);
            },
            icon: const Icon(Icons.close),
          ),
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
                  PasswordTextFieldComponent(
                    label: 'Nowe hasło',
                    isRequired: true,
                    controller: _newPasswordController,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 32),
                  PasswordTextFieldComponent(
                    label: 'Obecne hasło',
                    isRequired: true,
                    controller: _currentPasswordController,
                  ),
                ],
              ),
            ),
          ),
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
      return AppLocalizations.of(context)!.invalid_password_message;
    }
    return null;
  }

  void _onSaveButtonPressed(BuildContext context) {
    unfocusInputs();
    context.read<ProfileBloc>().add(
          ProfileEventUpdatePassword(
            newPassword: _newPasswordController.text,
            currentPassword: _currentPasswordController.text,
          ),
        );
  }
}
