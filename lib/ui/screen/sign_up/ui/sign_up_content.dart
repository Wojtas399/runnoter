part of 'sign_up_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  _FormHeader(),
                  SizedBox(height: 32),
                  _SignUpForm(),
                  SizedBox(height: 32),
                  _SubmitButton(),
                  SizedBox(height: 16),
                  _AlternativeOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.sign_up_screen_title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
