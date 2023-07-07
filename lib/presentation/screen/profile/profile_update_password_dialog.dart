part of 'profile_screen.dart';

class _UpdatePasswordDialog extends StatefulWidget {
  final DialogMode dialogMode;

  const _UpdatePasswordDialog({
    required this.dialogMode,
  });

  @override
  State<StatefulWidget> createState() {
    return _UpdatePasswordDialogState();
  }
}

class _UpdatePasswordDialogState extends State<_UpdatePasswordDialog> {
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
          navigateBack(context: context);
        }
      },
      child: switch (widget.dialogMode) {
        DialogMode.normal => _UpdatePasswordNormalDialog(
            newPasswordController: _newPasswordController,
            currentPasswordController: _currentPasswordController,
            isSaveButtonDisabled: _isSaveButtonDisabled,
            newPasswordValidator: _validatePassword,
            onSaveButtonPressed: () => _onSaveButtonPressed(context),
          ),
        DialogMode.fullScreen => _UpdatePasswordFullScreenDialog(
            newPasswordController: _newPasswordController,
            currentPasswordController: _currentPasswordController,
            isSaveButtonDisabled: _isSaveButtonDisabled,
            newPasswordValidator: _validatePassword,
            onSaveButtonPressed: () => _onSaveButtonPressed(context),
          ),
      },
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

class _UpdatePasswordNormalDialog extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController currentPasswordController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) newPasswordValidator;
  final VoidCallback onSaveButtonPressed;

  const _UpdatePasswordNormalDialog({
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
      content: Container(
        padding: const EdgeInsets.all(16),
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
          onPressed: () => navigateBack(context: context),
          child: LabelLarge(
            Str.of(context).cancel,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        TextButton(
          onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
          child: Text(Str.of(context).save),
        ),
      ],
    );
  }
}

class _UpdatePasswordFullScreenDialog extends StatelessWidget {
  final TextEditingController newPasswordController;
  final TextEditingController currentPasswordController;
  final bool isSaveButtonDisabled;
  final String? Function(String? value) newPasswordValidator;
  final VoidCallback onSaveButtonPressed;

  const _UpdatePasswordFullScreenDialog({
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
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
            child: Text(Str.of(context).save),
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
