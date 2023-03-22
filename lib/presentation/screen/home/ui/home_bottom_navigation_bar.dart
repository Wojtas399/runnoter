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
    final HomePage currentPage = context.select(
      (HomeBloc bloc) => bloc.state.currentPage,
    );

    return NavigationBar(
      onDestinationSelected: (int pageIndex) {
        _onCurrentPageChanged(context, pageIndex);
      },
      selectedIndex: currentPage.pageIndex,
      destinations: <NavigationDestination>[
        NavigationDestination(
          selectedIcon: const Icon(Icons.date_range),
          icon: const Icon(Icons.date_range_outlined),
          label: AppLocalizations.of(context)!.home_current_week_page_title,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.calendar_month),
          icon: const Icon(Icons.calendar_month_outlined),
          label: AppLocalizations.of(context)!.home_calendar_page_title,
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.health_and_safety),
          icon: const Icon(Icons.health_and_safety_outlined),
          label: AppLocalizations.of(context)!.home_pulse_and_weight_page_title,
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
