import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/cubit/today_measurement_cubit.dart';
import 'health_content.dart';

@RoutePage()
class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TodayMeasurementCubit()..initialize()),
        BlocProvider(
          create: (_) => HealthBloc()
            ..add(const HealthEventInitializeChartDateRangeListener()),
        )
      ],
      child: const HealthContent(),
    );
  }
}
