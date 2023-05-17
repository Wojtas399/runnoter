import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavPage page = context.select(
      (HomeBloc bloc) => bloc.state.bottomNavPage,
    );
    final str = Str.of(context);

    return NavigationBar(
      onDestinationSelected: (int pageIndex) {
        _onCurrentPageChanged(context, pageIndex);
      },
      selectedIndex: page.pageIndex,
      destinations: <NavigationDestination>[
        NavigationDestination(
          selectedIcon: const Icon(Icons.date_range),
          icon: const Icon(Icons.date_range_outlined),
          label: str.homeCurrentWeekPageTitle,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.calendar_month),
          icon: const Icon(Icons.calendar_month_outlined),
          label: str.homeCalendarPageTitle,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.health_and_safety),
          icon: const Icon(Icons.health_and_safety_outlined),
          label: str.homeHealthPageTitle,
        ),
      ],
    );
  }

  void _onCurrentPageChanged(BuildContext context, int homePageIndex) {
    context.read<HomeBloc>().add(
          HomeEventBottomNavPageChanged(
            bottomNavPage: BottomNavPage.values[homePageIndex],
          ),
        );
  }
}
