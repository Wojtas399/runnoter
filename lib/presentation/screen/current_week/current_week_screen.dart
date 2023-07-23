import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/current_week/current_week_cubit.dart';
import 'current_week_content.dart';

@RoutePage()
class CurrentWeekScreen extends StatelessWidget {
  const CurrentWeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CurrentWeekCubit()..initialize(),
      child: const CurrentWeekContent(),
    );
  }
}
