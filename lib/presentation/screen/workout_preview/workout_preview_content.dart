part of 'workout_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: _ScreenAdjustableBody(
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

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Str.of(context).workoutPreviewScreenTitle),
      centerTitle: true,
      actions: context.isMobileSize ? const [_WorkoutActions()] : null,
    );
  }
}

class _ScreenAdjustableBody extends StatelessWidget {
  final Widget child;

  const _ScreenAdjustableBody({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktopSize || MediaQuery.of(context).size.height < 700) {
      return ScreenAdjustableBody(
        maxContentWidth: bigContentWidth,
        child: child,
      );
    }
    return Paddings24(child: child);
  }
}
