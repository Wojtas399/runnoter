part of 'sign_in_screen.dart';

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldComponent(
          label: AppLocalizations.of(context)!.email,
          icon: Icons.email,
        ),
        const SizedBox(height: 24),
        const PasswordTextFieldComponent(),
      ],
    );
  }
}
