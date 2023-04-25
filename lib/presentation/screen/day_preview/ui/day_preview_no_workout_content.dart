part of 'day_preview_screen.dart';

class _NoWorkoutContent extends StatelessWidget {
  const _NoWorkoutContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _NoWorkoutInfo(),
        _Date(),
      ],
    );
  }
}

class _NoWorkoutInfo extends StatelessWidget {
  const _NoWorkoutInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.day_preview_screen_no_workout_title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.day_preview_screen_no_workout_message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        CustomFilledButton(
          label: AppLocalizations.of(context)!
              .day_preview_screen_add_workout_button_label,
          onPressed: () {
            _onButtonPressed(context);
          },
        ),
      ],
    );
  }

  void _onButtonPressed(BuildContext context) {
    final DateTime? date = context.read<DayPreviewBloc>().state.date;
    if (date != null) {
      navigateTo(
        context: context,
        route: WorkoutCreatorRoute(
          arguments: date,
        ),
      );
    }
  }
}
