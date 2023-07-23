import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../service/distance_unit_service.dart';
import '../service/language_service.dart';
import '../service/pace_unit_service.dart';
import '../service/theme_service.dart';

class ServicesProvider extends StatelessWidget {
  final Widget child;

  const ServicesProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<LanguageService>(
          create: (_) => LanguageService(),
        ),
        BlocProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
        BlocProvider(
          create: (_) => DistanceUnitService(),
        ),
        BlocProvider(
          create: (_) => PaceUnitService(),
        ),
      ],
      child: child,
    );
  }
}
