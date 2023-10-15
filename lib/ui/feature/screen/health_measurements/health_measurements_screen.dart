import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'health_measurements_content.dart';
import 'health_measurements_cubit.dart';

@RoutePage()
class HealthMeasurementsScreen extends StatelessWidget {
  const HealthMeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HealthMeasurementsCubit()..initialize(),
      child: const HealthMeasurementsContent(),
    );
  }
}
