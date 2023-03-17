import 'package:flutter/material.dart';

import 'home_app_bar.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: Center(
        child: Text('Welcome home!'),
      ),
    );
  }
}
