part of 'sign_up_screen.dart';

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 24);

    return Column(
      children: const [
        TextFieldComponent(
          icon: Icons.person,
          label: 'Imię',
        ),
        gap,
        TextFieldComponent(
          icon: Icons.person,
          label: 'Nazwisko',
        ),
        gap,
        TextFieldComponent(
          icon: Icons.email,
          label: 'Email',
        ),
        gap,
        PasswordTextFieldComponent(),
        gap,
        PasswordTextFieldComponent(
          label: 'Password confirmation',
        ),
      ],
    );
  }
}
