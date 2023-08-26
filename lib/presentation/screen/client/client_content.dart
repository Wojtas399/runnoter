import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import 'client_details.dart';

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
            appBar: AppBar(
              backgroundColor:
                  context.isMobileSize ? theme.colorScheme.primary : bckColor,
              foregroundColor: context.isMobileSize ? theme.canvasColor : null,
              centerTitle: true,
              title: const _AppBarTitle(),
              actions: [
                const ClientDetailsIcon(),
                if (context.isMobileSize)
                  const GapHorizontal8()
                else
                  const GapHorizontal16(),
              ],
              bottom: context.isMobileSize
                  ? _TabBar(onPageChanged: tabsRouter.setActiveIndex)
                  : null,
            ),
            body: SafeArea(
              child: Row(
                children: [
                  if (context.isDesktopSize)
                    _Drawer(
                      activePageIndex: tabsRouter.activeIndex,
                      onPageChanged: tabsRouter.setActiveIndex,
                    ),
                  if (context.isTabletSize)
                    _Rail(
                      activePageIndex: tabsRouter.activeIndex,
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

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final String? fullName = context.select(
      (ClientBloc bloc) => bloc.state.name == null || bloc.state.surname == null
          ? null
          : '${bloc.state.name} ${bloc.state.surname}',
    );
    final theme = Theme.of(context);

    return fullName == null
        ? CircularProgressIndicator(color: theme.canvasColor)
        : TitleLarge(
            fullName,
            textAlign: context.isMobileSize ? TextAlign.center : null,
            overflow: context.isMobileSize ? TextOverflow.ellipsis : null,
            color: context.isMobileSize
                ? theme.canvasColor
                : theme.colorScheme.primary,
          );
  }
}

class _TabBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int pageIndex) onPageChanged;

  const _TabBar({required this.onPageChanged});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final str = Str.of(context);

    return TabBar(
      labelColor: colorScheme.inversePrimary,
      unselectedLabelColor: colorScheme.outlineVariant.withOpacity(0.75),
      indicatorColor: colorScheme.inversePrimary,
      onTap: onPageChanged,
      labelStyle: Theme.of(context).textTheme.labelSmall,
      tabs: [
        Tab(icon: const Icon(Icons.event_note), text: str.calendarTitle),
        Tab(icon: const Icon(Icons.bar_chart), text: str.clientStatsTitle),
        Tab(icon: const Icon(Icons.emoji_events), text: str.racesTitle),
        Tab(icon: const Icon(Icons.water_drop), text: str.bloodTestsTitle),
      ],
    );
  }
}

class _Drawer extends StatelessWidget {
  final int activePageIndex;
  final Function(int destinationIndex) onPageChanged;

  const _Drawer({required this.activePageIndex, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return NavigationDrawer(
      selectedIndex: activePageIndex,
      onDestinationSelected: onPageChanged,
      children: [
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
  final Color backgroundColor;
  final Function(int destinationIndex) onPageChanged;

  const _Rail({
    required this.activePageIndex,
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
