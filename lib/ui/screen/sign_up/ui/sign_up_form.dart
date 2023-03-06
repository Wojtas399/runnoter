part of 'sign_up_screen.dart';

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 24);

    return Column(
      children: [
        TextFieldComponent(
          icon: Icons.person,
          label: AppLocalizations.of(context)!.name,
        ),
        gap,
        TextFieldComponent(
          icon: Icons.person,
          label: AppLocalizations.of(context)!.surname,
        ),
        gap,
        TextFieldComponent(
          icon: Icons.email,
          label: AppLocalizations.of(context)!.email,
        ),
        gap,
        const PasswordTextFieldComponent(),
        gap,
        PasswordTextFieldComponent(
          label: AppLocalizations.of(context)!.passwordConfirmation,
        ),
      ],
    );
  }
}
