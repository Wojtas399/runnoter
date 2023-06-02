part of 'blood_test_creator_screen.dart';

class _AllParameters extends StatelessWidget {
  const _AllParameters();

  @override
  Widget build(BuildContext context) {
    final List<BloodParameterResult>? parameterResults = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.parameterResults,
    );

    if (parameterResults == null) {
      return const SizedBox();
    }
    return BloodParameterResultsList(
      isEditMode: true,
      parameterResults: parameterResults,
      onParameterValueChanged: (
        BloodParameter parameter,
        double? value,
      ) {
        _onValueChanged(context, parameter, value);
      },
    );
  }

  void _onValueChanged(
    BuildContext context,
    BloodParameter parameter,
    double? value,
  ) {
    context.read<BloodTestCreatorBloc>().add(
          BloodTestCreatorEventParameterResultChanged(
            parameter: parameter,
            value: value,
          ),
        );
  }
}
