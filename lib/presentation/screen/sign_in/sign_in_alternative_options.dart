part of 'sign_in_screen.dart';

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _onSignUpOptionSelected,
          child: Text(
            Str.of(context).signInSignUpOption,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _onForgotPasswordSelected,
          child: Text(
            Str.of(context).signInForgotPasswordOption,
          ),
        ),
      ],
    );
  }

  void _onSignUpOptionSelected() {
    navigateTo(
      route: const SignUpRoute(),
    );
  }

  void _onForgotPasswordSelected() {
    navigateTo(
      route: const ForgotPasswordRoute(),
    );
  }
}
