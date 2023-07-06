part of 'sign_up_screen.dart';

class _AlternativeOptions extends StatelessWidget {
  const _AlternativeOptions();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onPressed(context);
      },
      child: Text(
        Str.of(context).signUpSignInOption,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    navigateBack(context: context);
  }
}
