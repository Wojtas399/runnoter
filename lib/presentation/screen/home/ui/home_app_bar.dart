import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DrawerPage drawerPage;

  const HomeAppBar({
    super.key,
    required this.drawerPage,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final List<String> drawerPageTitles = [
      str.homeDrawerHome,
      str.homeDrawerProfile,
      str.homeDrawerMileage,
      str.homeDrawerBlood,
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
