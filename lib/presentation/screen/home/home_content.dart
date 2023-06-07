part of 'home_screen.dart';

class _Content extends StatelessWidget {
  final List<Widget> pages = [
    _BottomNavPage(),
    const ProfileScreen(),
    const MileageScreen(),
    const BloodTestsScreen(),
    const CompetitionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final DrawerPage drawerPage = context.select(
      (HomeBloc bloc) => bloc.state.drawerPage,
    );

    return Scaffold(
      appBar: _AppBar(drawerPage: drawerPage),
      drawer: _Drawer(drawerPage: drawerPage),
      bottomNavigationBar:
          drawerPage == DrawerPage.home ? const _BottomNavigationBar() : null,
      floatingActionButton: drawerPage == DrawerPage.tournaments
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                _onFloatingActionButtonPressed(context);
              },
            )
          : null,
      body: SafeArea(
        child: pages[drawerPage.index],
      ),
    );
  }

  void _onFloatingActionButtonPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const CompetitionCreatorRoute(),
    );
  }
}

class _BottomNavPage extends StatelessWidget {
  final List<Widget> pages = const [
    CurrentWeekScreen(),
    CalendarScreen(),
    HealthScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavPage page = context.select(
      (HomeBloc bloc) => bloc.state.bottomNavPage,
    );

    return pages[page.index];
  }
}
