part of 'workout_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MediumBody(
            child: Paddings24(
              child: _WorkoutInfo(),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Str.of(context).workoutPreviewTitle),
      centerTitle: true,
      actions: context.isMobileSize ? const [_WorkoutActions()] : null,
    );
  }
}

class _WorkoutInfo extends StatelessWidget {
  const _WorkoutInfo();

  @override
  Widget build(BuildContext context) {
    final bool areDataLoaded = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.areDataLoaded,
    );

    return areDataLoaded ? const _Workout() : const LoadingInfo();
  }
}
