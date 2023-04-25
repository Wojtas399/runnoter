part of 'day_preview_screen.dart';

class DayPreviewContent extends StatelessWidget {
  const DayPreviewContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.day_preview_screen_title,
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: _Workout(),
        ),
      ),
    );
  }
}

class _Workout extends StatelessWidget {
  const _Workout();

  @override
  Widget build(BuildContext context) {
    final Workout? workout = context.select(
      (DayPreviewBloc bloc) => bloc.state.workout,
    );

    if (workout == null) {
      return const _NoWorkoutContent();
    }
    return const _WorkoutContent();
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (DayPreviewBloc bloc) => bloc.state.date,
    );

    return Text(
      date?.toUIFormat(context) ?? '',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
