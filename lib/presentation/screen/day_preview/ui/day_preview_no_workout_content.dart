part of 'day_preview_screen.dart';

class _NoWorkoutContent extends StatelessWidget {
  const _NoWorkoutContent();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
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
          Str.of(context).dayPreviewNoWorkoutTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const _NoWorkoutMessage(),
        const SizedBox(height: 24),
        BigButton(
          label: Str.of(context).dayPreviewAddWorkoutButton,
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
          creatorArguments: WorkoutCreatorAddModeArguments(
            date: date,
          ),
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
    String message = Str.of(context).dayPreviewNoWorkoutMessageFutureDay;
    if (isPastDay) {
      message = Str.of(context).dayPreviewNoWorkoutMessagePastDay;
    }
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
