import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../health/ui/health_screen.dart';
import '../../screens.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'home_app_bar.dart';
import 'home_bottom_navigation_bar.dart';
import 'home_drawer.dart';

class HomeContent extends StatelessWidget {
  final List<Widget> pages = [
    _BottomNavPage(),
    const ProfileScreen(),
    const MileageScreen(),
    const BloodScreen(),
    const SizedBox(),
  ];

  HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DrawerPage drawerPage = context.select(
      (HomeBloc bloc) => bloc.state.drawerPage,
    );

    return Scaffold(
      appBar: HomeAppBar(drawerPage: drawerPage),
      drawer: HomeDrawer(drawerPage: drawerPage),
      bottomNavigationBar: drawerPage == DrawerPage.home
          ? const HomeBottomNavigationBar()
          : null,
      body: SafeArea(
        child: pages[drawerPage.index],
      ),
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
