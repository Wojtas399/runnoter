part of 'sign_in_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(24, kToolbarHeight, 24, 0),
              child: Column(
                children: const [
                  _Logo(),
                  SizedBox(height: 24),
                  _FormHeader(),
                  SizedBox(height: 32),
                  _SignInForm(),
                  SizedBox(height: 32),
                  _SignInSubmitButton(),
                  SizedBox(height: 16),
                  _SignInAlternativeOptions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/logo.png');
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.sign_in_screen_title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
