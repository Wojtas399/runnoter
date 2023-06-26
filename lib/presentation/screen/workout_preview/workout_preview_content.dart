part of 'workout_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: Paddings24(
          child: BlocSelector<WorkoutPreviewBloc, WorkoutPreviewState, bool>(
            selector: (state) => state.areDataLoaded,
            builder: (_, bool areDataLoaded) =>
                areDataLoaded ? const _Workout() : const LoadingInfo(),
          ),
        ),
      ),
    );
  }
}
