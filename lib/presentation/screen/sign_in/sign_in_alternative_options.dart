part of 'sign_in_screen.dart';

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _onSignUpOptionSelected,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(str.signInDontHaveAccount),
                const SizedBox(width: 4),
                BodyMedium(
                  str.signInSignUp,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _onForgotPasswordSelected,
            child: Text(str.signInForgotPasswordOption),
          ),
        ),
      ],
    );
  }

  void _onSignUpOptionSelected() {
    navigateTo(const SignUpRoute());
  }

  void _onForgotPasswordSelected() {
    navigateTo(const ForgotPasswordRoute());
  }
}
