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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _passwordController.addListener(_checkPasswordsCorrectness);
    _passwordConfirmationController.addListener(_checkPasswordsCorrectness);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.removeListener(_checkPasswordsCorrectness);
    _passwordConfirmationController.removeListener(_checkPasswordsCorrectness);
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
          passwordController: _passwordController,
          passwordConfirmationController: _passwordConfirmationController,
          isSaveButtonDisabled: _isSaveButtonDisabled,
          passwordValidator: _validatePassword,
          passwordConfirmationValidator: _validatePasswordConfirmation,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
        ),
        desktopBody: _NormalDialog(
          passwordController: _passwordController,
          passwordConfirmationController: _passwordConfirmationController,
          isSaveButtonDisabled: _isSaveButtonDisabled,
          passwordValidator: _validatePassword,
          passwordConfirmationValidator: _validatePasswordConfirmation,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
        ),
      ),
    );
  }

  void _checkPasswordsCorrectness() {
    final String password = _passwordController.text;
    final String passwordConfirmation = _passwordConfirmationController.text;
    setState(() {
      _isSaveButtonDisabled = password.isEmpty ||
          !isPasswordValid(password) ||
          passwordConfirmation.isEmpty ||
          password != passwordConfirmation;
    });
  }

  String? _validatePassword(String? value) =>
      value != null && !isPasswordValid(value)
          ? Str.of(context).invalidPasswordMessage
          : null;

  String? _validatePasswordConfirmation(String? value) =>
      value != null && value != _passwordController.text
          ? Str.of(context).invalidPasswordConfirmationMessage
          : null;

  Future<void> _onSaveButtonPressed(BuildContext context) async {
    unfocusInputs();
    final bloc = context.read<ProfileIdentitiesBloc>();
    final bool reauthenticated = await askForReauthentication();
    if (reauthenticated) {
      bloc.add(
        ProfileIdentitiesEventUpdatePassword(
          newPassword: _passwordController.text,
        ),
      );
    }
  }
}

class _NormalDialog extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) passwordValidator;
  final String? Function(String? value) passwordConfirmationValidator;
  final VoidCallback onSaveButtonPressed;

  const _NormalDialog({
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.isSaveButtonDisabled,
    required this.passwordValidator,
    required this.passwordConfirmationValidator,
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
              controller: passwordController,
              validator: passwordValidator,
            ),
            const SizedBox(height: 24),
            PasswordTextFieldComponent(
              label: str.profileNewPasswordDialogNewPasswordConfirmation,
              isRequired: true,
              controller: passwordConfirmationController,
              validator: passwordConfirmationValidator,
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
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) passwordValidator;
  final String? Function(String? value) passwordConfirmationValidator;
  final VoidCallback onSaveButtonPressed;

  const _FullScreenDialog({
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.isSaveButtonDisabled,
    required this.passwordValidator,
    required this.passwordConfirmationValidator,
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
                  controller: passwordController,
                  validator: passwordValidator,
                ),
                const SizedBox(height: 24),
                PasswordTextFieldComponent(
                  label: str.profileNewPasswordDialogNewPasswordConfirmation,
                  isRequired: true,
                  controller: passwordConfirmationController,
                  validator: passwordConfirmationValidator,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
