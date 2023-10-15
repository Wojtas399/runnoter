import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/user.dart';
import '../../../component/gap/gap_components.dart';
import '../../../config/navigation/router.dart';
import '../../../extension/context_extensions.dart';
import 'cubit/home_cubit.dart';
import 'home_clients_notifications_badge.dart';
import 'home_fab.dart';

class HomeNavigationDrawer extends StatelessWidget {
  final int? selectedIndex;
  final RouteData currentRoute;
  final Function(int pageIndex) onPageSelected;

  const HomeNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.currentRoute,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final AccountType? accountType = context.select(
      (HomeCubit cubit) => cubit.state.accountType,
    );
    final str = Str.of(context);

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: onPageSelected,
      children: [
        if (context.isDesktopSize &&
            currentRoute.name != ProfileRoute.name) ...[
          const Gap16(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: HomeDrawerFAB(currentRoute: currentRoute),
          ),
          const Gap24(),
        ] else
          const Gap32(),
        if (context.isMobileSize) const _AppLogo(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: const Icon(Icons.calendar_month),
          label: Text(str.calendarTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.health_and_safety_outlined),
          selectedIcon: const Icon(Icons.health_and_safety),
          label: Text(str.healthTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.insert_chart_outlined),
          selectedIcon: const Icon(Icons.insert_chart),
          label: Text(str.mileageTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Text(str.bloodTestsTitle),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Text(str.racesTitle),
        ),
        if (accountType == AccountType.coach)
          NavigationDrawerDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(str.clientsTitle),
                  const HomeClientsNotificationsBadge(),
                ],
              ),
            ),
          ),
        const Gap24(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.logout_outlined),
          label: Text(Str.of(context).homeSignOut),
        ),
      ],
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 24),
      child: Image.asset('assets/logo.png'),
    );
  }
}
