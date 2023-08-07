import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/gap/gap_components.dart';
import '../../extension/context_extensions.dart';

class HomeNavigationDrawer extends StatelessWidget {
  final int? selectedIndex;
  final Function(int pageIndex) onPageSelected;

  const HomeNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: onPageSelected,
      children: [
        const Gap32(),
        if (context.isMobileSize) const _AppLogo(),
        if (context.isMobileSize)
          NavigationDrawerDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: Text(str.homeTitle),
          ),
        if (!context.isMobileSize)
          NavigationDrawerDestination(
            icon: const Icon(Icons.date_range_outlined),
            selectedIcon: const Icon(Icons.date_range),
            label: Text(str.currentWeekTitle),
          ),
        if (!context.isMobileSize)
          NavigationDrawerDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: Text(str.calendarTitle),
          ),
        if (!context.isMobileSize)
          NavigationDrawerDestination(
            icon: const Icon(Icons.health_and_safety_outlined),
            selectedIcon: const Icon(Icons.health_and_safety),
            label: Text(str.healthTitle),
          ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.insert_chart_outlined),
          selectedIcon: const Icon(Icons.insert_chart),
          label: Text(str.mileageTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Text(str.bloodTestsTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Text(str.racesTitle),
        ),
        const Gap24(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.logout_outlined),
          label: Text(Str.of(context).homeSignOut),
        ),
      ],
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 24),
      child: Image.asset('assets/logo.png'),
    );
  }
}
