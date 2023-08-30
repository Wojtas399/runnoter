import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/padding/paddings_24.dart';
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
    return ResponsiveLayout(
      mobileBody: _FullScreenDialog(
        passwordController: _passwordController,
        passwordConfirmationController: _passwordConfirmationController,
        isSaveButtonDisabled: _isSaveButtonDisabled,
        passwordValidator: _validatePassword,
        passwordConfirmationValidator: _validatePasswordConfirmation,
        onSave: () => _onSave(context),
      ),
      desktopBody: _NormalDialog(
        passwordController: _passwordController,
        passwordConfirmationController: _passwordConfirmationController,
        isSaveButtonDisabled: _isSaveButtonDisabled,
        passwordValidator: _validatePassword,
        passwordConfirmationValidator: _validatePasswordConfirmation,
        onSave: () => _onSave(context),
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

  Future<void> _onSave(BuildContext context) async {
    if (_isSaveButtonDisabled) return;
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
  final VoidCallback onSave;

  const _NormalDialog({
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.isSaveButtonDisabled,
    required this.passwordValidator,
    required this.passwordConfirmationValidator,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.profileNewPasswordDialogTitle),
      content: SizedBox(
        width: 400,
        child: _Form(
          passwordController: passwordController,
          passwordConfirmationController: passwordConfirmationController,
          passwordValidator: passwordValidator,
          passwordConfirmationValidator: passwordConfirmationValidator,
          onSave: onSave,
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
          onPressed: isSaveButtonDisabled ? null : onSave,
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
  final VoidCallback onSave;

  const _FullScreenDialog({
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.isSaveButtonDisabled,
    required this.passwordValidator,
    required this.passwordConfirmationValidator,
    required this.onSave,
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
            onPressed: isSaveButtonDisabled ? null : onSave,
            child: Text(str.save),
          ),
          const GapHorizontal16(),
        ],
      ),
      body: SafeArea(
        child: Paddings24(
          child: _Form(
            passwordController: passwordController,
            passwordConfirmationController: passwordConfirmationController,
            passwordValidator: passwordValidator,
            passwordConfirmationValidator: passwordConfirmationValidator,
            onSave: onSave,
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final String? Function(String? value) passwordValidator;
  final String? Function(String? value) passwordConfirmationValidator;
  final VoidCallback onSave;

  const _Form({
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.passwordValidator,
    required this.passwordConfirmationValidator,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PasswordTextFieldComponent(
          label: str.profileNewPasswordDialogNewPassword,
          isRequired: true,
          controller: passwordController,
          validator: passwordValidator,
          onTapOutside: (_) => unfocusInputs(),
          onSubmitted: (_) => onSave(),
        ),
        const Gap24(),
        PasswordTextFieldComponent(
          label: str.profileNewPasswordDialogNewPasswordConfirmation,
          isRequired: true,
          controller: passwordConfirmationController,
          validator: passwordConfirmationValidator,
          onSubmitted: (_) => onSave(),
        ),
      ],
    );
  }
}
