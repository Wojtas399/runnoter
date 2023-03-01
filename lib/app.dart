import 'package:flutter/material.dart';

import 'config/theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runnoter',
      theme: GlobalTheme.lightTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Hello world!'),
        ),
      ),
    );
  }
}
