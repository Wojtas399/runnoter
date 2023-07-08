part of 'workout_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: _PlatformDependableBody(
          child: BlocSelector<WorkoutPreviewBloc, WorkoutPreviewState, bool>(
            selector: (state) => state.areDataLoaded,
            builder: (_, bool areDataLoaded) {
              return areDataLoaded ? const _Workout() : const LoadingInfo();
            },
          ),
        ),
      ),
    );
  }
}

class _PlatformDependableBody extends StatelessWidget {
  final Widget child;

  const _PlatformDependableBody({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktopSize || MediaQuery.of(context).size.height < 700) {
      return SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: maxContentWidth),
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ],
          ),
        ),
      );
    }
    return Paddings24(child: child);
  }
}
