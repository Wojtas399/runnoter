part of 'home_screen.dart';

enum _MobileDrawerPage {
  home,
  mileage,
  blood,
  races,
  profile,
}

enum _MobileBottomNavPage {
  currentWeek,
  calendar,
  health,
}

class _MobileContent extends StatefulWidget {
  const _MobileContent();

  @override
  State<StatefulWidget> createState() => _MobileContentState();
}

class _MobileContentState extends State<_MobileContent> {
  _MobileDrawerPage _drawerPage = _MobileDrawerPage.home;
  _MobileBottomNavPage _bottomNavPage = _MobileBottomNavPage.currentWeek;

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final drawerPageTitles = [
      str.homeTitle,
      str.homeMileageTitle,
      str.homeBloodTestsTitle,
      str.homeRacesTitle,
      str.homeProfileTitle,
    ];
    final bottomNavPageTitles = [
      str.homeCurrentWeekTitle,
      str.homeCalendarTitle,
      str.homeHealthTitle,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _drawerPage == _MobileDrawerPage.home
              ? bottomNavPageTitles[_bottomNavPage.index]
              : drawerPageTitles[_drawerPage.index],
        ),
        centerTitle: true,
      ),
      drawer: _NavigationDrawer(
        selectedIndex: _drawerPage.index,
        destinations: [
          _DestinationHome(context: context),
          _DestinationMileage(context: context),
          _DestinationBlood(context: context),
          _DestinationRaces(context: context),
          _DestinationProfile(context: context),
        ],
        onDestinationSelected: _onDrawerPageSelected,
      ),
      bottomNavigationBar: _drawerPage == _MobileDrawerPage.home
          ? _BottomNavigationBar(
              page: _bottomNavPage,
              onPageChanged: _onBottomNavPageChanged,
            )
          : null,
      floatingActionButton: _drawerPage == _MobileDrawerPage.blood ||
              _drawerPage == _MobileDrawerPage.races
          ? FloatingActionButton(
              onPressed: _onFloatingActionButtonPressed,
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: switch (_drawerPage) {
          _MobileDrawerPage.home => switch (_bottomNavPage) {
              _MobileBottomNavPage.currentWeek => const CurrentWeekScreen(),
              _MobileBottomNavPage.calendar => const CalendarScreen(),
              _MobileBottomNavPage.health => const HealthScreen(),
            },
          _MobileDrawerPage.profile => const ProfileScreen(),
          _MobileDrawerPage.mileage => const MileageScreen(),
          _MobileDrawerPage.blood => const BloodTestsScreen(),
          _MobileDrawerPage.races => const RacesScreen(),
        },
      ),
    );
  }

  void _onDrawerPageSelected(int pageIndex) {
    setState(() {
      _drawerPage = _MobileDrawerPage.values[pageIndex];
    });
  }

  void _onBottomNavPageChanged(_MobileBottomNavPage page) {
    setState(() {
      _bottomNavPage = page;
    });
  }

  void _onFloatingActionButtonPressed() {
    if (_drawerPage == _MobileDrawerPage.blood) {
      navigateTo(
        route: const BloodTestCreatorRoute(),
      );
    } else if (_drawerPage == _MobileDrawerPage.races) {
      navigateTo(
        route: const RaceCreatorRoute(),
      );
    }
  }
}
