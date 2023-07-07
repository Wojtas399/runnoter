part of 'home_screen.dart';

enum _DesktopDrawerPage {
  currentWeek,
  calendar,
  health,
  mileage,
  blood,
  races,
  profile,
}

class _DesktopContent extends StatefulWidget {
  const _DesktopContent();

  @override
  State<StatefulWidget> createState() => _DesktopContentState();
}

class _DesktopContentState extends State<_DesktopContent> {
  _DesktopDrawerPage _page = _DesktopDrawerPage.currentWeek;

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final pageTitles = [
      str.homeCurrentWeekTitle,
      str.homeCalendarTitle,
      str.homeHealthTitle,
      str.homeMileageTitle,
      str.homeBloodTestsTitle,
      str.homeRacesTitle,
      str.homeProfileTitle,
    ];
    final List<_Destination> destinations = [
      _DestinationCurrentWeek(context: context),
      _DestinationCalendar(context: context),
      _DestinationHealth(context: context),
      _DestinationMileage(context: context),
      _DestinationBlood(context: context),
      _DestinationRaces(context: context),
      _DestinationProfile(context: context),
    ];

    return Row(
      children: [
        if (MediaQuery.of(context).size.width > maxTabletWidth)
          _NavigationDrawer(
            selectedIndex: _page.index,
            destinations: destinations,
            onDestinationSelected: _onPageSelected,
          ),
        if (MediaQuery.of(context).size.width <= maxTabletWidth)
          _NavigationRail(
            selectedIndex: _page.index,
            destinations: destinations,
            onDestinationSelected: _onPageSelected,
          ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: Text(pageTitles[_page.index]),
              centerTitle: true,
            ),
            floatingActionButton: _page == _DesktopDrawerPage.blood ||
                    _page == _DesktopDrawerPage.races
                ? FloatingActionButton(
                    onPressed: _onFloatingActionButtonPressed,
                    child: const Icon(Icons.add),
                  )
                : null,
            body: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: switch (_page) {
                        _DesktopDrawerPage.currentWeek =>
                          const CurrentWeekScreen(),
                        _DesktopDrawerPage.calendar => const CalendarScreen(),
                        _DesktopDrawerPage.health => const HealthScreen(),
                        _DesktopDrawerPage.profile => const ProfileScreen(),
                        _DesktopDrawerPage.mileage => const MileageScreen(),
                        _DesktopDrawerPage.blood => const BloodTestsScreen(),
                        _DesktopDrawerPage.races => const RacesScreen(),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onPageSelected(int pageIndex) {
    setState(() {
      _page = _DesktopDrawerPage.values[pageIndex];
    });
  }

  void _onFloatingActionButtonPressed() {
    if (_page == _DesktopDrawerPage.blood) {
      navigateTo(
        context: context,
        route: const BloodTestCreatorRoute(),
      );
    } else if (_page == _DesktopDrawerPage.races) {
      navigateTo(
        context: context,
        route: const RaceCreatorRoute(),
      );
    }
  }
}
