part of 'workout_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.workout_creator_screen_title,
        ),
      ),
      body: SafeArea(
        child: ScrollableContent(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: const [
                  _WorkoutName(),
                  SizedBox(height: 24),
                  _WorkoutStagesSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutName extends StatelessWidget {
  const _WorkoutName();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: AppLocalizations.of(context)!.workout_creator_screen_workout_name,
      isRequired: true,
      onChanged: (String? workoutName) {
        _onChanged(context, workoutName);
      },
    );
  }

  void _onChanged(BuildContext context, String? workoutName) {
    context.read<WorkoutCreatorBloc>().add(
          WorkoutCreatorEventWorkoutNameChanged(
            workoutName: workoutName,
          ),
        );
  }
}
