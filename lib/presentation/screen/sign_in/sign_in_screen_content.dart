part of 'sign_in_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: ScrollableContent(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: Center(
              child: Card(
                elevation: screenWidth < 500 ? 0 : null,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(screenWidth < 500 ? 24 : 32),
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const Column(
                    children: [
                      _Logo(),
                      SizedBox(height: 24),
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
    return HeadlineMedium(
      Str.of(context).signInScreenTitle,
      fontWeight: FontWeight.bold,
    );
  }
}
