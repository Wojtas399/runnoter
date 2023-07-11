part of 'blood_test_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: bigContentWidth),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateSection(),
                Expanded(
                  child: _Results(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: _Date(),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestPreviewBloc bloc) => bloc.state.date,
    );

    return TitleLarge(
      date?.toFullDate(context) ?? '--',
    );
  }
}

class _Results extends StatelessWidget {
  const _Results();

  @override
  Widget build(BuildContext context) {
    final List<BloodParameterResult>? parameterResults = context.select(
      (BloodTestPreviewBloc bloc) => bloc.state.parameterResults,
    );

    return BloodParameterResultsList(
      parameterResults: parameterResults,
    );
  }
}
