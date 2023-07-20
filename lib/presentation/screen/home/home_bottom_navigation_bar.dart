import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int pageIndex) onPageSelected;

  const HomeBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return NavigationBar(
      onDestinationSelected: onPageSelected,
      selectedIndex: selectedIndex,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.date_range_outlined),
          selectedIcon: const Icon(Icons.date_range),
          label: str.currentWeekTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: const Icon(Icons.calendar_month),
          label: str.calendarTitle,
        ),
        NavigationDestination(
          icon: const Icon(Icons.health_and_safety_outlined),
          selectedIcon: const Icon(Icons.health_and_safety),
          label: str.healthTitle,
        ),
      ],
    );
  }
}
