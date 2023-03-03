part of 'sign_in_screen.dart';

class _SignInAlternativeOptions extends StatelessWidget {
  const _SignInAlternativeOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Nie masz konta? Zarejestruj się!'),
        SizedBox(height: 8),
        Text('Zapomniałeś hasła'),
      ],
    );
  }
}
