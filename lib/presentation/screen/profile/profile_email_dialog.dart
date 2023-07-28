import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text_field_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../../service/validation_service.dart';

class ProfileEmailDialog extends StatefulWidget {
  const ProfileEmailDialog({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileEmailDialog> {
  final TextEditingController _emailController = TextEditingController();
  late final String? _originalEmail;
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _originalEmail = context.read<ProfileIdentitiesBloc>().state.email ?? '';
    _emailController.text = _originalEmail ?? '';
    _emailController.addListener(_checkValuesCorrectness);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkValuesCorrectness);
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
          isSaveButtonDisabled: _isSaveButtonDisabled,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
          emailController: _emailController,
          emailValidator: _validateEmail,
        ),
        desktopBody: _NormalDialog(
          isSaveButtonDisabled: _isSaveButtonDisabled,
          onSaveButtonPressed: () => _onSaveButtonPressed(context),
          emailController: _emailController,
          emailValidator: _validateEmail,
        ),
      ),
    );
  }

  void _checkValuesCorrectness() {
    final String email = _emailController.text;
    setState(() {
      _isSaveButtonDisabled =
          email.isEmpty || email == _originalEmail || !isEmailValid(email);
    });
  }

  String? _validateEmail(String? value) {
    if (value != null && !isEmailValid(value)) {
      return Str.of(context).invalidEmailMessage;
    }
    return null;
  }

  Future<void> _onSaveButtonPressed(BuildContext context) async {
    unfocusInputs();
    final bloc = context.read<ProfileIdentitiesBloc>();
    final bool reauthenticated = await askForReauthentication();
    if (reauthenticated) {
      bloc.add(
        ProfileIdentitiesEventUpdateEmail(newEmail: _emailController.text),
      );
    }
  }
}

class _NormalDialog extends StatelessWidget {
  final bool isSaveButtonDisabled;
  final VoidCallback onSaveButtonPressed;
  final TextEditingController emailController;
  final String? Function(String? value) emailValidator;

  const _NormalDialog({
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
    required this.emailController,
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
  final bool isSaveButtonDisabled;
  final VoidCallback onSaveButtonPressed;
  final TextEditingController emailController;
  final String? Function(String? value) emailValidator;

  const _FullScreenDialog({
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
    required this.emailController,
    required this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(str.profileNewEmailDialogTitle),
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
                TextFieldComponent(
                  label: str.email,
                  isRequired: true,
                  controller: emailController,
                  validator: emailValidator,
                  icon: Icons.email,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
