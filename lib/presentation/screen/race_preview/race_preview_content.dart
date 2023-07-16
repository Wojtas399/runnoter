part of 'race_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: _ScreenAdjustableBody(
          child: BlocSelector<RacePreviewBloc, RacePreviewState, bool>(
            selector: (state) => state.race != null,
            builder: (_, bool isRaceLoaded) =>
                isRaceLoaded ? const _Race() : const LoadingInfo(),
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
      title: Text(Str.of(context).racePreviewTitle),
      centerTitle: true,
      actions: context.isMobileSize ? const [_RaceActions()] : null,
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
        maxContentWidth: GetIt.I.get<BodySizes>().mediumBodyWidth,
        child: child,
      );
    }
    return Paddings24(child: child);
  }
}
