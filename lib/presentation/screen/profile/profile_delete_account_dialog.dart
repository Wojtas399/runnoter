import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../component/password_text_field_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

class ProfileDeleteAccountDialog extends StatefulWidget {
  const ProfileDeleteAccountDialog({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileDeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _passwordController.addListener(_updateDeleteButtonDisableStatus);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updateDeleteButtonDisableStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _FullScreenDialog(
        passwordController: _passwordController,
        isSaveButtonDisabled: _isSaveButtonDisabled,
        onSaveButtonPressed: () => _onSaveButtonPressed(context),
      ),
      desktopBody: _NormalDialog(
        passwordController: _passwordController,
        isSaveButtonDisabled: _isSaveButtonDisabled,
        onSaveButtonPressed: () => _onSaveButtonPressed(context),
      ),
    );
  }

  void _updateDeleteButtonDisableStatus() {
    setState(() {
      _isSaveButtonDisabled = _passwordController.text.isEmpty;
    });
  }

  void _onSaveButtonPressed(BuildContext context) {
    context.read<ProfileIdentitiesBloc>().add(
          ProfileIdentitiesEventDeleteAccount(
            password: _passwordController.text,
          ),
        );
  }
}

class _NormalDialog extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isSaveButtonDisabled;
  final VoidCallback? onSaveButtonPressed;

  const _NormalDialog({
    required this.passwordController,
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.profileDeleteAccountDialogTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BodyLarge(str.profileDeleteAccountDialogMessage),
            const SizedBox(height: 24),
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
          onPressed: popRoute,
          child: LabelLarge(
            str.cancel,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FilledButton(
          onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(str.delete),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isSaveButtonDisabled;
  final VoidCallback? onSaveButtonPressed;

  const _FullScreenDialog({
    required this.passwordController,
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(str.profileDeleteAccountDialogTitle),
        leading: const CloseButton(),
        actions: [
          FilledButton(
            onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(str.delete),
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
                BodyLarge(str.profileDeleteAccountDialogMessage),
                const SizedBox(height: 24),
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
