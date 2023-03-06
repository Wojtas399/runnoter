part of 'sign_up_screen.dart';

class _AlternativeOption extends StatelessWidget {
  const _AlternativeOption();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onPressed(context);
      },
      child: const Text(
        'Masz już konto? Zaloguj się!',
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(context: context, route: Routes.signIn);
  }
}
