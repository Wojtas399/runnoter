part of 'forgot_password_screen.dart';

class ForgotPasswordContent extends StatelessWidget {
  const ForgotPasswordContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithLogo(),
      body: SafeArea(
        child: GestureDetector(
          onTap: unfocusInputs,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: const Column(
              children: [
                _Header(),
                SizedBox(height: 32),
                _Email(),
                SizedBox(height: 32),
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadlineMedium(
          Str.of(context).forgotPasswordScreenTitle,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        Text(
          Str.of(context).forgotPasswordMessage,
        )
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      isRequired: true,
      label: Str.of(context).email,
      icon: Icons.email,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<ForgotPasswordBloc>().add(
          ForgotPasswordEventEmailChanged(email: value ?? ''),
        );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ForgotPasswordBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).forgotPasswordSubmitButtonLabel,
      isDisabled: isDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<ForgotPasswordBloc>().add(
          const ForgotPasswordEventSubmit(),
        );
  }
}
