part of 'blood_test_preview_screen.dart';

class _Results extends StatelessWidget {
  const _Results();

  @override
  Widget build(BuildContext context) {
    final List<BloodReadingParameter>? readParameters = context.select(
      (BloodReadingPreviewBloc bloc) => bloc.state.readParameters,
    );

    return BloodReadingParametersComponent(
      readParameters: readParameters,
    );
  }
}
