part of 'home_screen.dart';

enum _NavigationType { drawer, rail }

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final int numberOfBottomNavPages = 3;
  final int numberOfAllPages = 6;
  int _bottomNavSelectedIndex = 0;
  _NavigationType _navigationType = _NavigationType.drawer;

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        CurrentWeekRoute(),
        CalendarRoute(),
        HealthRoute(),
        MileageRoute(),
        BloodTestsRoute(),
        RacesRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final int activeIndex = tabsRouter.activeIndex;
        final int? mobileDrawerActiveIndex = activeIndex < numberOfAllPages
            ? activeIndex < numberOfBottomNavPages
                ? 0
                : activeIndex - 2
            : null;
        final int? desktopDrawerActiveIndex =
            activeIndex < numberOfAllPages ? activeIndex : null;
        final Color? bckColor = context.isMobileSize
            ? null
            : Color.alphaBlend(
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.surface,
              );

        return Scaffold(
          backgroundColor: bckColor,
          appBar: _AppBar(
            backgroundColor: bckColor,
            onMenuPressed: _onMenuAppBarPressed,
            onAvatarPressed: () => tabsRouter.setActiveIndex(6),
          ),
          drawer: context.isMobileSize
              ? _NavigationDrawer(
                  selectedIndex: mobileDrawerActiveIndex,
                  onPageSelected: (int pageIndex) =>
                      _onSidePageSelected(pageIndex, tabsRouter),
                )
              : null,
          bottomNavigationBar:
              context.isMobileSize && _isHomePage(tabsRouter.current)
                  ? _BottomNavigationBar(
                      selectedIndex: _bottomNavSelectedIndex,
                      onPageSelected: (int pageIndex) =>
                          _onBottomPageSelected(pageIndex, tabsRouter),
                    )
                  : null,
          body: SafeArea(
            child: Row(
              children: [
                if (context.isDesktopSize)
                  switch (_navigationType) {
                    _NavigationType.drawer => _NavigationDrawer(
                        selectedIndex: desktopDrawerActiveIndex,
                        onPageSelected: (int pageIndex) =>
                            _onSidePageSelected(pageIndex, tabsRouter),
                      ),
                    _NavigationType.rail => _NavigationRail(
                        selectedIndex: desktopDrawerActiveIndex,
                        backgroundColor: bckColor,
                        onPageSelected: (int pageIndex) =>
                            _onSidePageSelected(pageIndex, tabsRouter),
                      ),
                  },
                if (!context.isMobileSize && !context.isDesktopSize)
                  _NavigationRail(
                    selectedIndex: desktopDrawerActiveIndex,
                    backgroundColor: bckColor,
                    onPageSelected: (int pageIndex) =>
                        _onSidePageSelected(pageIndex, tabsRouter),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: context.isMobileSize ? 0 : 24,
                      bottom: context.isMobileSize ? 0 : 24,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: bigContentWidth,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onMenuAppBarPressed() {
    setState(() {
      _navigationType = switch (_navigationType) {
        _NavigationType.drawer => _NavigationType.rail,
        _NavigationType.rail => _NavigationType.drawer,
      };
    });
  }

  Future<void> _onSidePageSelected(int pageIndex, TabsRouter tabsRouter) async {
    if (context.isMobileSize) {
      if (pageIndex == 4) {
        await _signOut(context);
      } else if (pageIndex == 0) {
        tabsRouter.setActiveIndex(_bottomNavSelectedIndex);
      } else {
        tabsRouter.setActiveIndex(pageIndex + 2);
      }
    } else {
      if (pageIndex == 6) {
        await _signOut(context);
      } else {
        tabsRouter.setActiveIndex(pageIndex);
      }
    }
  }

  void _onBottomPageSelected(int pageIndex, TabsRouter tabsRouter) {
    tabsRouter.setActiveIndex(pageIndex);
    setState(() {
      _bottomNavSelectedIndex = pageIndex;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    final HomeBloc bloc = context.read<HomeBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: str.homeSignOutConfirmationDialogTitle,
      message: str.homeSignOutConfirmationDialogMessage,
      confirmButtonLabel: str.homeSignOut,
    );
    if (confirmed == true) {
      bloc.add(
        const HomeEventSignOut(),
      );
    }
  }

  bool _isHomePage(RouteData routeData) =>
      routeData.name == CurrentWeekRoute.name ||
      routeData.name == CalendarRoute.name ||
      routeData.name == HealthRoute.name;
}
