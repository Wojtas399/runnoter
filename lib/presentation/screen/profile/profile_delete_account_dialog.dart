part of 'profile_screen.dart';

class _DeleteAccountDialog extends StatefulWidget {
  final DialogMode dialogMode;

  const _DeleteAccountDialog({
    required this.dialogMode,
  });

  @override
  State<StatefulWidget> createState() {
    return _DeleteAccountDialogState();
  }
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
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
    return BlocListener<ProfileIdentitiesBloc, ProfileIdentitiesState>(
      listener: (BuildContext context, ProfileIdentitiesState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusComplete &&
            blocStatus.info == ProfileInfo.accountDeleted) {
          navigateBack(context: context);
        }
      },
      child: switch (widget.dialogMode) {
        DialogMode.normal => _DeleteAccountNormalDialog(
            passwordController: _passwordController,
            isSaveButtonDisabled: _isSaveButtonDisabled,
            onSaveButtonPressed: () => _onSaveButtonPressed(context),
          ),
        DialogMode.fullScreen => _DeleteAccountFullScreenDialog(
            passwordController: _passwordController,
            isSaveButtonDisabled: _isSaveButtonDisabled,
            onSaveButtonPressed: () => _onSaveButtonPressed(context),
          ),
      },
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

class _DeleteAccountNormalDialog extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isSaveButtonDisabled;
  final VoidCallback? onSaveButtonPressed;

  const _DeleteAccountNormalDialog({
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
          onPressed: () => navigateBack(context: context),
          child: LabelLarge(
            str.cancel,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        TextButton(
          onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
          child: Text(str.delete),
        ),
      ],
    );
  }
}

class _DeleteAccountFullScreenDialog extends StatelessWidget {
  final TextEditingController passwordController;
  final bool isSaveButtonDisabled;
  final VoidCallback? onSaveButtonPressed;

  const _DeleteAccountFullScreenDialog({
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
        leading: IconButton(
          onPressed: () => navigateBack(context: context),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: isSaveButtonDisabled ? null : onSaveButtonPressed,
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
