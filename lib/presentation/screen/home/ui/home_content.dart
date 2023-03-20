import 'package:flutter/material.dart';

import 'home_app_bar.dart';
import 'home_bottom_navigation_bar.dart';
import 'home_drawer.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      drawer: HomeDrawer(),
      bottomNavigationBar: HomeBottomNavigationBar(),
      body: Center(
        child: Text('Welcome home!'),
      ),
    );
  }
}
