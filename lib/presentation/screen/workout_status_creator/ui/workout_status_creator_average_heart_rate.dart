part of 'workout_status_creator_screen.dart';

class _AverageHeartRate extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

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
              .averageHeartRate
              ?.toString() ??
          '';
    }

    return TextFieldComponent(
      label: AppLocalizations.of(context)!
          .workout_status_creator_average_heart_rate,
      maxLength: 3,
      keyboardType: TextInputType.number,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
      onChanged: (String? averageHeartRateStr) {
        _onChanged(context, averageHeartRateStr);
      },
    );
  }

  void _onChanged(BuildContext context, String? averageHeartRateStr) {
    if (averageHeartRateStr == null) {
      return;
    }
    final int? averageHeartRate = int.tryParse(averageHeartRateStr);
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventAvgHeartRateChanged(
            averageHeartRate: averageHeartRate,
          ),
        );
  }
}
