part of 'home_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final DrawerPage drawerPage;

  const _AppBar({
    required this.drawerPage,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final List<String> drawerPageTitles = [
      str.homeDrawerHome,
      str.homeDrawerProfile,
      str.homeDrawerMileage,
      str.homeDrawerBloodTests,
      str.homeDrawerCompetitions,
    ];
    final List<String> bottomNavPageTitles = [
      str.homeCurrentWeekPageTitle,
      str.homeCalendarPageTitle,
      str.homeHealthPageTitle,
    ];
    final BottomNavPage bottomNavPage = context.select(
      (HomeBloc bloc) => bloc.state.bottomNavPage,
    );

    return AppBar(
      title: Text(
        drawerPage == DrawerPage.home
            ? bottomNavPageTitles[bottomNavPage.index]
            : drawerPageTitles[drawerPage.index],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
