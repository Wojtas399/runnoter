part of 'sign_in_screen.dart';

class _SignInAlternativeOptions extends StatelessWidget {
  const _SignInAlternativeOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _onSignUpOptionSelected(context);
          },
          child: Text(
            AppLocalizations.of(context)!.sign_in_screen_sign_up_option_info,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!
              .sign_in_screen_forgot_password_option_info,
        ),
      ],
    );
  }

  void _onSignUpOptionSelected(BuildContext context) {
    navigateTo(
      context: context,
      route: Routes.signUp,
    );
  }
}
