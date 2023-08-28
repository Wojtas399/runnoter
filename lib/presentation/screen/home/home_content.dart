import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../dependency_injection.dart';
import '../../../domain/additional_model/coaching_request.dart';
import '../../../domain/bloc/home/home_bloc.dart';
import '../../../domain/entity/user.dart';
import '../../../domain/service/auth_service.dart';
import '../../config/navigation/router.dart';
import '../../dialog/persons_search/persons_search_dialog.dart';
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
  int _bottomNavSelectedIndex = 0;
  _NavigationType _navigationType = _NavigationType.drawer;

  @override
  Widget build(BuildContext context) {
    final AccountType? accountType = context.select(
      (HomeBloc bloc) => bloc.state.accountType,
    );
    final List<PageRouteInfo> routes = [
      const CalendarRoute(),
      const HealthRoute(),
      const MileageRoute(),
      const BloodTestsRoute(),
      const RacesRoute(),
      if (accountType == AccountType.coach) const ClientsRoute(),
      const ProfileRoute(),
    ];
    final int numberOfAllPages = routes.length;

    return AutoTabsRouter(
      routes: routes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final RouteData currentPage = tabsRouter.current;
        final int activeIndex = tabsRouter.activeIndex;
        final int? mobileDrawerActiveIndex = activeIndex < numberOfAllPages - 1
            ? activeIndex < numberOfBottomNavPages
                ? 0
                : activeIndex - 2
            : null;
        final int? desktopDrawerActiveIndex =
            activeIndex < numberOfAllPages - 1 ? activeIndex : null;
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
            onAvatarPressed: () => tabsRouter.setActiveIndex(
              numberOfAllPages - 1,
            ),
          ),
          drawer: context.isMobileSize
              ? HomeNavigationDrawer(
                  selectedIndex: mobileDrawerActiveIndex,
                  onPageSelected: (int pageIndex) => _onSidePageSelected(
                    pageIndex,
                    tabsRouter,
                    numberOfAllPages,
                  ),
                )
              : null,
          bottomNavigationBar: context.isMobileSize && _isHomePage(currentPage)
              ? HomeBottomNavigationBar(
                  selectedIndex: _bottomNavSelectedIndex,
                  onPageSelected: (int pageIndex) =>
                      _onBottomPageSelected(pageIndex, tabsRouter),
                )
              : null,
          floatingActionButton: _isFloatingButtonRequired(context, currentPage)
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
                        onPageSelected: (int pageIndex) => _onSidePageSelected(
                          pageIndex,
                          tabsRouter,
                          numberOfAllPages,
                        ),
                      ),
                    _NavigationType.rail => HomeNavigationRail(
                        selectedIndex: desktopDrawerActiveIndex,
                        backgroundColor: bckColor,
                        onPageSelected: (int pageIndex) => _onSidePageSelected(
                          pageIndex,
                          tabsRouter,
                          numberOfAllPages,
                        ),
                      ),
                  },
                if (context.isTabletSize)
                  HomeNavigationRail(
                    selectedIndex: desktopDrawerActiveIndex,
                    backgroundColor: bckColor,
                    onPageSelected: (int pageIndex) => _onSidePageSelected(
                      pageIndex,
                      tabsRouter,
                      numberOfAllPages,
                    ),
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

  Future<void> _onSidePageSelected(
    int pageIndex,
    TabsRouter tabsRouter,
    int numberOfAllPages,
  ) async {
    if (context.isMobileSize) {
      if (pageIndex == numberOfAllPages - 3) {
        await _signOut(context);
      } else if (pageIndex == 0) {
        tabsRouter.setActiveIndex(_bottomNavSelectedIndex);
      } else {
        tabsRouter.setActiveIndex(pageIndex + 2);
      }
    } else {
      if (pageIndex == numberOfAllPages - 1) {
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
      title: Text(str.homeSignOutConfirmationDialogTitle),
      content: Text(str.homeSignOutConfirmationDialogMessage),
      confirmButtonLabel: str.homeSignOut,
      displayConfirmationButtonAsFilled: true,
    );
    if (confirmed == true) {
      bloc.add(const HomeEventSignOut());
    }
  }

  bool _isHomePage(RouteData routeData) =>
      routeData.name == CalendarRoute.name ||
      routeData.name == HealthRoute.name;

  bool _isFloatingButtonRequired(BuildContext context, RouteData currentPage) =>
      context.isMobileSize &&
      (currentPage.name == BloodTestsRoute.name ||
          currentPage.name == RacesRoute.name ||
          currentPage.name == ClientsRoute.name);

  Future<void> _onFloatingActionButtonPressed(RouteData currentPage) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    if (currentPage.name == BloodTestsRoute.name) {
      navigateTo(BloodTestCreatorRoute(userId: loggedUserId));
    } else if (currentPage.name == RacesRoute.name) {
      navigateTo(RaceCreatorRoute(userId: loggedUserId));
    } else if (currentPage.name == ClientsRoute.name) {
      showDialogDependingOnScreenSize(const PersonsSearchDialog(
        requestDirection: CoachingRequestDirection.coachToClient,
      ));
    }
  }
}
