part of 'workout_status_creator_screen.dart';

class _CoveredDistance extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _CoveredDistance();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutStatusCreatorInfo.workoutStatusInitialized) {
      _controller.text = context
              .read<WorkoutStatusCreatorBloc>()
              .state
              .coveredDistanceInKm
              ?.toString() ??
          '';
    }

    return TextFieldComponent(
      label:
          '${AppLocalizations.of(context)!.workout_status_creator_covered_distance_label} [km]',
      maxLength: 8,
      keyboardType: TextInputType.number,
      isRequired: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      controller: _controller,
      onChanged: (String? coveredDistanceInKmStr) {
        _onChanged(context, coveredDistanceInKmStr);
      },
    );
  }

  void _onChanged(BuildContext context, String? coveredDistanceInKmStr) {
    if (coveredDistanceInKmStr == null) {
      return;
    }
    final double? coveredDistanceInKm = double.tryParse(coveredDistanceInKmStr);
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventCoveredDistanceInKmChanged(
            coveredDistanceInKm: coveredDistanceInKm,
          ),
        );
  }
}
