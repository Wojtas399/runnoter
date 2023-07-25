import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/home/home_bloc.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'home_app_bar.dart';
import 'home_bottom_navigation_bar.dart';
import 'home_navigation_drawer.dart';
import 'home_navigation_rail.dart';

enum _NavigationType { drawer, rail }

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HomeContent> {
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
        final RouteData currentPage = tabsRouter.current;
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
          appBar: HomeAppBar(
            backgroundColor: bckColor,
            onMenuPressed: _onMenuAppBarPressed,
            onAvatarPressed: () => tabsRouter.setActiveIndex(6),
          ),
          drawer: context.isMobileSize
              ? HomeNavigationDrawer(
                  selectedIndex: mobileDrawerActiveIndex,
                  onPageSelected: (int pageIndex) =>
                      _onSidePageSelected(pageIndex, tabsRouter),
                )
              : null,
          bottomNavigationBar: context.isMobileSize && _isHomePage(currentPage)
              ? HomeBottomNavigationBar(
                  selectedIndex: _bottomNavSelectedIndex,
                  onPageSelected: (int pageIndex) =>
                      _onBottomPageSelected(pageIndex, tabsRouter),
                )
              : null,
          floatingActionButton: context.isMobileSize &&
                  (_isBloodTestsPage(currentPage) || _isRacesPage(currentPage))
              ? FloatingActionButton(
                  onPressed: () => _onFloatingActionButtonPressed(currentPage),
                  child: const Icon(Icons.add),
                )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                if (context.isDesktopSize)
                  switch (_navigationType) {
                    _NavigationType.drawer => HomeNavigationDrawer(
                        selectedIndex: desktopDrawerActiveIndex,
                        onPageSelected: (int pageIndex) =>
                            _onSidePageSelected(pageIndex, tabsRouter),
                      ),
                    _NavigationType.rail => HomeNavigationRail(
                        selectedIndex: desktopDrawerActiveIndex,
                        backgroundColor: bckColor,
                        onPageSelected: (int pageIndex) =>
                            _onSidePageSelected(pageIndex, tabsRouter),
                      ),
                  },
                if (context.isTabletSize)
                  HomeNavigationRail(
                    selectedIndex: desktopDrawerActiveIndex,
                    backgroundColor: bckColor,
                    onPageSelected: (int pageIndex) =>
                        _onSidePageSelected(pageIndex, tabsRouter),
                  ),
                Expanded(child: child),
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

  bool _isBloodTestsPage(RouteData routeData) =>
      routeData.name == BloodTestsRoute.name;

  bool _isRacesPage(RouteData routeData) => routeData.name == RacesRoute.name;

  void _onFloatingActionButtonPressed(RouteData routeData) {
    if (_isBloodTestsPage(routeData)) {
      navigateTo(BloodTestCreatorRoute());
    } else if (_isRacesPage(routeData)) {
      navigateTo(RaceCreatorRoute());
    }
  }
}
