part of 'sign_up_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithLogo(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: Center(
              child: Container(
                color: Colors.transparent,
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _FormHeader(),
                    SizedBox(height: 32),
                    _Form(),
                    SizedBox(height: 32),
                    _SubmitButton(),
                    SizedBox(height: 16),
                    _AlternativeOptions(),
                  ],
                ),
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
    return HeadlineMedium(
      Str.of(context).signUpScreenTitle,
      fontWeight: FontWeight.bold,
    );
  }
}
