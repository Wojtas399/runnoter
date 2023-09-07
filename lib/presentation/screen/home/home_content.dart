import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/home/home_cubit.dart';
import '../../../domain/entity/user.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';
import 'home_app_bar.dart';
import 'home_fab.dart';
import 'home_navigation_drawer.dart';
import 'home_navigation_rail.dart';

enum _NavigationType { drawer, rail }

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<HomeContent> {
  _NavigationType _navigationType = _NavigationType.drawer;

  @override
  Widget build(BuildContext context) {
    final AccountType? accountType = context.select(
      (HomeCubit cubit) => cubit.state.accountType,
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
        final RouteData currentRoute = tabsRouter.current;
        final Color? bckColor = context.isMobileSize
            ? null
            : Color.alphaBlend(
                Theme.of(context).colorScheme.primary.withOpacity(0.05),
                Theme.of(context).colorScheme.surface,
              );
        final int? activeIndex = tabsRouter.activeIndex < routes.length - 1
            ? tabsRouter.activeIndex
            : null;

        return Scaffold(
          backgroundColor: bckColor,
          appBar: (context.isMobileSize
              ? HomeMobileAppBar(
                  currentRoute: currentRoute,
                  onMenuPressed: _onMenuAppBarPressed,
                  onAvatarPressed: () => tabsRouter.setActiveIndex(
                    numberOfAllPages - 1,
                  ),
                )
              : HomeDesktopAppBar(
                  backgroundColor: bckColor,
                  onMenuPressed: _onMenuAppBarPressed,
                  onAvatarPressed: () => tabsRouter.setActiveIndex(
                    numberOfAllPages - 1,
                  ),
                )) as PreferredSizeWidget,
          drawer: context.isMobileSize
              ? HomeNavigationDrawer(
                  selectedIndex: activeIndex,
                  currentRoute: currentRoute,
                  onPageSelected: (int pageIndex) => _onPageSelected(
                    pageIndex,
                    tabsRouter,
                    numberOfAllPages,
                  ),
                )
              : null,
          floatingActionButton:
              context.isMobileSize && currentRoute.name != ProfileRoute.name
                  ? HomeMobileFAB(currentRoute: currentRoute)
                  : null,
          body: SafeArea(
            child: Row(
              children: [
                if (context.isDesktopSize)
                  switch (_navigationType) {
                    _NavigationType.drawer => HomeNavigationDrawer(
                        selectedIndex: activeIndex,
                        currentRoute: currentRoute,
                        onPageSelected: (int pageIndex) => _onPageSelected(
                          pageIndex,
                          tabsRouter,
                          numberOfAllPages,
                        ),
                      ),
                    _NavigationType.rail => HomeNavigationRail(
                        selectedIndex: activeIndex,
                        currentRoute: currentRoute,
                        backgroundColor: bckColor,
                        onPageSelected: (int pageIndex) => _onPageSelected(
                          pageIndex,
                          tabsRouter,
                          numberOfAllPages,
                        ),
                      ),
                  },
                if (context.isTabletSize)
                  HomeNavigationRail(
                    selectedIndex: activeIndex,
                    currentRoute: currentRoute,
                    backgroundColor: bckColor,
                    onPageSelected: (int pageIndex) => _onPageSelected(
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

  Future<void> _onPageSelected(
    int pageIndex,
    TabsRouter tabsRouter,
    int numberOfAllPages,
  ) async {
    if (pageIndex == numberOfAllPages - 1) {
      await _signOut(context);
    } else {
      tabsRouter.setActiveIndex(pageIndex);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final HomeCubit cubit = context.read<HomeCubit>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: Text(str.homeSignOutConfirmationDialogTitle),
      content: Text(str.homeSignOutConfirmationDialogMessage),
      confirmButtonLabel: str.homeSignOut,
      displayConfirmationButtonAsFilled: true,
    );
    if (confirmed == true) cubit.signOut();
  }
}
