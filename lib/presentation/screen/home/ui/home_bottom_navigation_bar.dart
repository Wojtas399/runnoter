import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HomePage currentPage = context.select(
      (HomeBloc bloc) => bloc.state.currentPage,
    );

    return NavigationBar(
      onDestinationSelected: (int pageIndex) {
        _onCurrentPageChanged(context, pageIndex);
      },
      selectedIndex: currentPage.pageIndex,
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

  void _onCurrentPageChanged(BuildContext context, int pageIndex) {
    context.read<HomeBloc>().add(
          HomeEventCurrentPageChanged(
            currentPage: HomePage.values[pageIndex],
          ),
        );
  }
}
