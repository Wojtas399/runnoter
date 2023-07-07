part of 'profile_screen.dart';

class _UpdateEmailDialog extends StatefulWidget {
  final DialogMode dialogMode;

  const _UpdateEmailDialog({
    required this.dialogMode,
  });

  @override
  State<StatefulWidget> createState() => _UpdateEmailDialogState();
}

class _UpdateEmailDialogState extends State<_UpdateEmailDialog> {
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
      child: switch (widget.dialogMode) {
        DialogMode.normal => _UpdateEmailNormalDialog(
            isSaveButtonDisabled: _isSaveButtonDisabled,
            onSaveButtonPressed: () => _onSaveButtonPressed(context),
            emailController: _emailController,
            passwordController: _passwordController,
            emailValidator: _validateEmail,
          ),
        DialogMode.fullScreen => _UpdateEmailFullScreenDialog(
            isSaveButtonDisabled: _isSaveButtonDisabled,
            onSaveButtonPressed: () => _onSaveButtonPressed(context),
            emailController: _emailController,
            passwordController: _passwordController,
            emailValidator: _validateEmail,
          ),
      },
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

class _UpdateEmailNormalDialog extends StatelessWidget {
  final bool isSaveButtonDisabled;
  final VoidCallback onSaveButtonPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? Function(String? value) emailValidator;

  const _UpdateEmailNormalDialog({
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
    required this.emailController,
    required this.passwordController,
    required this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Str.of(context).profileNewEmailDialogTitle),
      content: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldComponent(
              label: Str.of(context).email,
              isRequired: true,
              controller: emailController,
              validator: emailValidator,
              icon: Icons.email,
            ),
            const SizedBox(height: 32),
            PasswordTextFieldComponent(
              label: Str.of(context).password,
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

class _UpdateEmailFullScreenDialog extends StatelessWidget {
  final bool isSaveButtonDisabled;
  final VoidCallback onSaveButtonPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? Function(String? value) emailValidator;

  const _UpdateEmailFullScreenDialog({
    required this.isSaveButtonDisabled,
    required this.onSaveButtonPressed,
    required this.emailController,
    required this.passwordController,
    required this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Str.of(context).profileNewEmailDialogTitle,
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
                TextFieldComponent(
                  label: Str.of(context).email,
                  isRequired: true,
                  controller: emailController,
                  validator: emailValidator,
                  icon: Icons.email,
                ),
                const SizedBox(height: 32),
                PasswordTextFieldComponent(
                  label: Str.of(context).password,
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
