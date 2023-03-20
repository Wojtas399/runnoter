import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        print('Selected $index');
      },
      selectedIndex: 0,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.date_range),
          icon: Icon(Icons.date_range_outlined),
          label: 'Obecny tydzień',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.calendar_month),
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Kalendarz',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.health_and_safety),
          icon: Icon(Icons.health_and_safety_outlined),
          label: 'Puls & Waga',
        ),
      ],
    );
  }
}
