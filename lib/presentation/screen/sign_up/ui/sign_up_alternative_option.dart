part of 'sign_up_screen.dart';

class _AlternativeOption extends StatelessWidget {
  const _AlternativeOption();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onPressed(context);
      },
      child: Text(
        AppLocalizations.of(context)!.sign_up_screen_sign_in_option,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(context: context, route: Routes.signIn);
  }
}
