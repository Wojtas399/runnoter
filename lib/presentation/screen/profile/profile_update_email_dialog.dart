import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../component/password_text_field_component.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text_field_component.dart';
import '../../extension/context_extensions.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../../service/validation_service.dart';

class ProfileUpdateEmailDialog extends StatefulWidget {
  const ProfileUpdateEmailDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileUpdateEmailDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final String? _originalEmail;
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _originalEmail = context.read<ProfileIdentitiesBloc>().state.email ?? '';
    _emailController.text = _originalEmail ?? '';
    _emailController.addListener(_checkValuesCorrectness);
    _passwordController.addListener(_checkValuesCorrectness);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkValuesCorrectness);
    _passwordController.removeListener(_checkValuesCorrectness);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileIdentitiesBloc, ProfileIdentitiesState>(
      listener: (BuildContext context, ProfileIdentitiesState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusComplete &&
            blocStatus.info == ProfileInfo.savedData) {
          navigateBack(context: context);
        }
      },
      child: context.isMobileSize
          ? _FullScreenDialog(
              isSaveButtonDisabled: _isSaveButtonDisabled,
              onSaveButtonPressed: () => _onSaveButtonPressed(context),
              emailController: _emailController,
              passwordController: _passwordController,
              emailValidator: _validateEmail,
            )
          : _NormalDialog(
              isSaveButtonDisabled: _isSaveButtonDisabled,
              onSaveButtonPressed: () => _onSaveButtonPressed(context),
              emailController: _emailController,
              passwordController: _passwordController,
              emailValidator: _validateEmail,
            ),
    );
  }

  void _checkValuesCorrectness() {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    setState(() {
      _isSaveButtonDisabled = email.isEmpty ||
          email == _originalEmail ||
          !isEmailValid(email) ||
          password.isEmpty;
    });
  }

  String? _validateEmail(String? value) {
    if (value != null && !isEmailValid(value)) {
      return Str.of(context).invalidEmailMessage;
    }
    return null;
  }

  void _onSaveButtonPressed(BuildContext context) {
    unfocusInputs();
    context.read<ProfileIdentitiesBloc>().add(
          ProfileIdentitiesEventUpdateEmail(
            newEmail: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }
}

class _NormalDialog extends StatelessWidget {
  final bool isSaveButtonDisabled;
  final VoidCallback onSaveButtonPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? Function(String? value) emailValidator;

  const _NormalDialog({
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
    required this.emailController,
    required this.passwordController,
    required this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.profileNewEmailDialogTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldComponent(
              label: str.email,
              isRequired: true,
              controller: emailController,
              validator: emailValidator,
              icon: Icons.email,
            ),
            const SizedBox(height: 32),
            PasswordTextFieldComponent(
              label: str.password,
              controller: passwordController,
              isRequired: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => navigateBack(context: context),
          child: LabelLarge(
            str.cancel,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        TextButton(
          onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
          child: Text(str.save),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  final bool isSaveButtonDisabled;
  final VoidCallback onSaveButtonPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? Function(String? value) emailValidator;

  const _FullScreenDialog({
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
    required this.emailController,
    required this.passwordController,
    required this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(str.profileNewEmailDialogTitle),
        leading: IconButton(
          onPressed: () => navigateBack(context: context),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
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
                TextFieldComponent(
                  label: str.email,
                  isRequired: true,
                  controller: emailController,
                  validator: emailValidator,
                  icon: Icons.email,
                ),
                const SizedBox(height: 32),
                PasswordTextFieldComponent(
                  label: str.password,
                  controller: passwordController,
                  isRequired: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
