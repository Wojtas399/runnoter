part of 'home_screen.dart';

class _BottomNavigationBar extends StatelessWidget {
  final _MobileBottomNavPage page;
  final Function(_MobileBottomNavPage page) onPageChanged;

  const _BottomNavigationBar({
    required this.page,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<_Destination> destinations = [
      _DestinationCurrentWeek(context: context),
      _DestinationCalendar(context: context),
      _DestinationHealth(context: context),
    ];

    return NavigationBar(
      onDestinationSelected: _onCurrentPageChanged,
      selectedIndex: page.index,
      destinations: <NavigationDestination>[
        ...destinations.map(
          (destination) => NavigationDestination(
            selectedIcon: Icon(destination.selectedIconData),
            icon: Icon(destination.iconData),
            label: destination.label,
          ),
        ),
      ],
    );
  }

  void _onCurrentPageChanged(int homePageIndex) {
    onPageChanged(
      _MobileBottomNavPage.values[homePageIndex],
    );
  }
}
