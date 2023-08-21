import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/title_text_components.dart';
import 'client_details.dart';

class ClientContentMobile extends StatelessWidget {
  final int activePageIndex;
  final Function(int pageIndex) onPageChanged;
  final Widget child;

  const ClientContentMobile({
    super.key,
    required this.activePageIndex,
    required this.onPageChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: activePageIndex,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          title: const _AppBarTitle(),
          actions: const [ClientDetailsIcon(), GapHorizontal8()],
          bottom: _TabBar(onPageChanged: onPageChanged),
        ),
        body: SafeArea(child: child),
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
            textAlign: TextAlign.center,
            color: Theme.of(context).canvasColor,
            overflow: TextOverflow.ellipsis,
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
        Tab(icon: const Icon(Icons.event_note), text: str.clientWorkoutsTitle),
        Tab(icon: const Icon(Icons.bar_chart), text: str.clientStatsTitle),
        Tab(icon: const Icon(Icons.emoji_events), text: str.racesTitle),
        Tab(icon: const Icon(Icons.water_drop), text: str.bloodTestsTitle),
      ],
    );
  }
}
