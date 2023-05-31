part of 'blood_test_preview_screen.dart';

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
