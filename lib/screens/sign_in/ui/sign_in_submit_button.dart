part of 'sign_in_screen.dart';

class _SignInSubmitButton extends StatelessWidget {
  const _SignInSubmitButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: AppLocalizations.of(context)!.sign_in_screen_button_label,
      onPressed: () {
        //TODO
      },
    );
  }
}
