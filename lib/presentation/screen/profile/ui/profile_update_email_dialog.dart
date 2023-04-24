import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/password_text_field_component.dart';
import '../../../component/text_field_component.dart';
import '../../../model/bloc_status.dart';
import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../../../service/validation_service.dart';
import '../bloc/profile_identities_bloc.dart';
import '../bloc/profile_identities_event.dart';
import '../bloc/profile_identities_state.dart';

class ProfileUpdateEmailDialog extends StatefulWidget {
  const ProfileUpdateEmailDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.profile_screen_new_email_dialog_title,
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
                  TextFieldComponent(
                    label: AppLocalizations.of(context)!.email,
                    isRequired: true,
                    controller: _emailController,
                    validator: _validateEmail,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 32),
                  PasswordTextFieldComponent(
                    label: AppLocalizations.of(context)!.password,
                    controller: _passwordController,
                    isRequired: true,
                  ),
                ],
              ),
            ),
          ),
        ),
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
      return AppLocalizations.of(context)!.invalid_email_message;
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
