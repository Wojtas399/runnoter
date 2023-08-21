import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/title_text_components.dart';
import 'client_details.dart';

class ClientContentDesktop extends StatelessWidget {
  final int activePageIndex;
  final Function(int pageIndex) onPageChanged;
  final Widget child;

  const ClientContentDesktop({
    super.key,
    required this.activePageIndex,
    required this.onPageChanged,
    required this.child,
  });

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
        actions: const [ClientDetailsIcon(), GapHorizontal16()],
      ),
      body: SafeArea(
        child: Row(
          children: [
            _Drawer(
              activePageIndex: activePageIndex,
              onPageChanged: onPageChanged,
            ),
            Expanded(child: child),
          ],
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
  final int activePageIndex;
  final Function(int destinationIndex) onPageChanged;

  const _Drawer({
    required this.activePageIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: activePageIndex,
      onDestinationSelected: onPageChanged,
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
