import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/gap/gap_components.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import 'client_app_bar.dart';
import 'client_fab.dart';

class ClientContent extends StatelessWidget {
  const ClientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        ClientCalendarRoute(),
        ClientStatsRoute(),
        ClientRacesRoute(),
        ClientBloodTestsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final theme = Theme.of(context);
        final Color bckColor = Color.alphaBlend(
          theme.colorScheme.primary.withOpacity(0.05),
          theme.colorScheme.surface,
        );

        return DefaultTabController(
          length: context.isMobileSize ? 4 : 0,
          child: Scaffold(
            backgroundColor: context.isMobileSize ? null : bckColor,
            appBar: (context.isMobileSize
                    ? ClientMobileAppBar(currentPage: tabsRouter.current)
                    : ClientDesktopAppBar(backgroundColor: bckColor))
                as PreferredSizeWidget,
            bottomNavigationBar: context.isMobileSize
                ? _BottomNavigation(
                    selectedIndex: tabsRouter.activeIndex,
                    onDestinationSelected: tabsRouter.setActiveIndex,
                  )
                : null,
            floatingActionButton: context.isMobileSize
                ? ClientFAB(currentRoute: tabsRouter.current)
                : null,
            body: SafeArea(
              child: Row(
                children: [
                  if (context.isDesktopSize)
                    _Drawer(
                      activePageIndex: tabsRouter.activeIndex,
                      currentRoute: tabsRouter.current,
                      onPageChanged: tabsRouter.setActiveIndex,
                    ),
                  if (context.isTabletSize)
                    _Rail(
                      activePageIndex: tabsRouter.activeIndex,
                      currentRoute: tabsRouter.current,
                      backgroundColor: bckColor,
                      onPageChanged: tabsRouter.setActiveIndex,
                    ),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onDestinationSelected;

  const _BottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.event_note_outlined),
          selectedIcon: const Icon(Icons.event_note),
          label: Str.of(context).calendarTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
          label: Str.of(context).clientStatsTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Str.of(context).racesTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Str.of(context).bloodTestsTitle,
        ),
      ],
    );
  }
}

class _Drawer extends StatelessWidget {
  final int activePageIndex;
  final RouteData currentRoute;
  final Function(int destinationIndex) onPageChanged;

  const _Drawer({
    required this.activePageIndex,
    required this.currentRoute,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return NavigationDrawer(
      selectedIndex: activePageIndex,
      onDestinationSelected: onPageChanged,
      children: [
        if (context.isDesktopSize) ...[
          const Gap16(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClientExtendedFAB(currentRoute: currentRoute),
          ),
          const Gap24(),
        ] else
          const Gap32(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.event_note_outlined),
          selectedIcon: const Icon(Icons.event_note),
          label: Text(str.calendarTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
          label: Text(str.clientStatsTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Text(str.racesTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Text(str.bloodTestsTitle),
        ),
      ],
    );
  }
}

class _Rail extends StatelessWidget {
  final int activePageIndex;
  final RouteData currentRoute;
  final Color backgroundColor;
  final Function(int destinationIndex) onPageChanged;

  const _Rail({
    required this.activePageIndex,
    required this.currentRoute,
    required this.backgroundColor,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      selectedIndex: activePageIndex,
      onDestinationSelected: onPageChanged,
      backgroundColor: backgroundColor,
      groupAlignment: -0.90,
      leading: ClientFAB(currentRoute: currentRoute),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.event_note_outlined),
          selectedIcon: const Icon(Icons.event_note),
          label: Text(str.calendarTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
          label: Text(str.clientStatsTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Text(str.racesTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Text(str.bloodTestsTitle),
        ),
      ],
    );
  }
}
