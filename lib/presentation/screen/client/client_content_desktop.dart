import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';

class ClientContentDesktop extends StatelessWidget {
  const ClientContentDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bckColor = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withOpacity(0.05),
      Theme.of(context).colorScheme.surface,
    );

    return Scaffold(
      backgroundColor: bckColor,
      appBar: AppBar(
        backgroundColor: bckColor,
        centerTitle: true,
        title: const _AppBarTitle(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info),
          ),
          const GapHorizontal16(),
        ],
      ),
      body: SafeArea(
        child: AutoTabsRouter(
          routes: const [
            ClientActivitiesRoute(),
            ClientStatsRoute(),
          ],
          builder: (BuildContext context, Widget child) {
            final tabsRouter = AutoTabsRouter.of(context);

            return Row(
              children: [
                _Drawer(
                  activeIndex: tabsRouter.activeIndex,
                  onDestinationSelected: (int destinationIndex) {
                    tabsRouter.setActiveIndex(destinationIndex);
                  },
                ),
                Expanded(child: child),
              ],
            );
          },
        ),
      ),
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

    return fullName == null
        ? CircularProgressIndicator(color: Theme.of(context).canvasColor)
        : TitleLarge(
            fullName,
            color: Theme.of(context).colorScheme.primary,
          );
  }
}

class _Drawer extends StatelessWidget {
  final int activeIndex;
  final Function(int destinationIndex) onDestinationSelected;

  const _Drawer({
    required this.activeIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: activeIndex,
      onDestinationSelected: onDestinationSelected,
      children: [
        const Gap32(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.event_note_outlined),
          selectedIcon: const Icon(Icons.event_note),
          label: Text(Str.of(context).clientWorkoutsTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.analytics_outlined),
          selectedIcon: const Icon(Icons.analytics),
          label: Text(Str.of(context).clientStatsTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Text(Str.of(context).racesTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Text(Str.of(context).bloodTestsTitle),
        ),
      ],
    );
  }
}
