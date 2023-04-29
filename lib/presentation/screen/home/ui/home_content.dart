import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pulse_and_weight/ui/pulse_and_weight_screen.dart';
import '../../screens.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'home_app_bar.dart';
import 'home_bottom_navigation_bar.dart';
import 'home_drawer.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const HomeDrawer(),
      bottomNavigationBar: const HomeBottomNavigationBar(),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  final List<Widget> pages = const [
    CurrentWeekScreen(),
    CalendarScreen(),
    PulseAndWeightScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final HomePage currentPage = context.select(
      (HomeBloc bloc) => bloc.state.currentPage,
    );

    return pages[currentPage.index];
  }
}
