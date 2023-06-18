part of 'day_preview_screen.dart';

class DayPreviewContent extends StatelessWidget {
  const DayPreviewContent({
    super.key,
  });

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
            const _Date(),
            Expanded(
              child: BlocSelector<DayPreviewBloc, DayPreviewState, String?>(
                selector: (state) => state.workoutId,
                builder: (_, String? workoutId) => switch (workoutId) {
                  null => const _NoWorkoutInfo(),
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

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (DayPreviewBloc bloc) => bloc.state.date,
    );

    return TitleLarge(
      date?.toFullDate(context) ?? '',
    );
  }
}
