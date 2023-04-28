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
        const _NoWorkoutMessage(),
        const SizedBox(height: 24),
        BigButton(
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

class _NoWorkoutMessage extends StatelessWidget {
  const _NoWorkoutMessage();

  @override
  Widget build(BuildContext context) {
    final bool? isPastDay = context.select(
      (DayPreviewBloc bloc) => bloc.state.isPastDay,
    );

    if (isPastDay == null) {
      return const SizedBox();
    }
    String message = AppLocalizations.of(context)!
        .day_preview_screen_no_workout_message_future_day;
    if (isPastDay) {
      message = AppLocalizations.of(context)!
          .day_preview_screen_no_workout_message_past_day;
    }
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
