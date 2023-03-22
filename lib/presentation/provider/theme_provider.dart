import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/theme_service.dart';

class ThemeProvider extends StatelessWidget {
  final Widget child;

  const ThemeProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeService>(
      create: (_) => ThemeService(),
      child: child,
    );
  }
}
