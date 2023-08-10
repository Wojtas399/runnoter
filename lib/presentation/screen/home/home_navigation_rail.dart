import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/bloc/home/home_bloc.dart';
import '../../../domain/entity/user.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/label_text_components.dart';

class HomeNavigationRail extends StatelessWidget {
  final int? selectedIndex;
  final Color? backgroundColor;
  final Function(int index) onPageSelected;

  const HomeNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.backgroundColor,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final AccountType? accountType = context.select(
      (HomeBloc bloc) => bloc.state.accountType,
    );
    final str = Str.of(context);

    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      backgroundColor: backgroundColor,
      groupAlignment: -0.90,
      trailing: Column(
        children: [
          const Gap32(),
          IconButton(
            onPressed: () => onPageSelected(7),
            icon: const Icon(Icons.logout_outlined),
          ),
          LabelMedium(Str.of(context).homeSignOut),
        ],
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.date_range_outlined),
          selectedIcon: const Icon(Icons.date_range),
          label: Text(str.currentWeekTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: const Icon(Icons.calendar_month),
          label: Text(str.calendarTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.health_and_safety_outlined),
          selectedIcon: const Icon(Icons.health_and_safety),
          label: Text(str.healthTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.insert_chart_outlined),
          selectedIcon: const Icon(Icons.insert_chart),
          label: Text(str.mileageTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Text(str.bloodTestsTitle),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Text(str.racesTitle),
        ),
        NavigationRailDestination(
          icon: Icon(MdiIcons.whistleOutline),
          selectedIcon: Icon(MdiIcons.whistle),
          label: Text(str.coachTitle),
        ),
        if (accountType == AccountType.coach)
          NavigationRailDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: Text(str.clientsTitle),
          ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onPageSelected,
    );
  }
}
