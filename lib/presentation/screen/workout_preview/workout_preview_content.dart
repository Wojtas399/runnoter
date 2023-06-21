part of 'workout_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Paddings24(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _WorkoutName(),
            Expanded(
              child: BlocSelector<WorkoutPreviewBloc, WorkoutPreviewState,
                  String?>(
                selector: (state) => state.workoutId,
                builder: (_, String? workoutId) => switch (workoutId) {
                  null => const LoadingInfo(),
                  String() => const _Workout(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutName extends StatelessWidget {
  const _WorkoutName();

  @override
  Widget build(BuildContext context) {
    final String? name = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.workoutName,
    );

    return TitleLarge(name ?? '');
  }
}
