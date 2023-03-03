part of 'sign_in_screen.dart';

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextFieldComponent(
          label: 'E-mail',
          icon: Icons.email,
        ),
        SizedBox(height: 24),
        PasswordTextFieldComponent(),
      ],
    );
  }
}
