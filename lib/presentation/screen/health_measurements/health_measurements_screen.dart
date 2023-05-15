import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/health_measurement.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';
import 'health_measurements_cubit.dart';

class HealthMeasurementsScreen extends StatelessWidget {
  const HealthMeasurementsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Health measurements screen'),
        ),
        body: const SafeArea(
          child: _Measurements(),
        ),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HealthMeasurementsCubit(
        authService: context.read<AuthService>(),
        healthMeasurementRepository:
            context.read<HealthMeasurementRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _Measurements extends StatelessWidget {
  const _Measurements();

  @override
  Widget build(BuildContext context) {
    final List<HealthMeasurement>? measurements = context.select(
      (HealthMeasurementsCubit cubit) => cubit.state,
    );

    if (measurements == null) {
      return const Center(
        child: Text('Brak pomiarów'),
      );
    }
    return ListView.builder(
      itemCount: measurements.length,
      padding: const EdgeInsets.all(24),
      itemBuilder: (_, int measurementIndex) => _MeasurementItem(
        measurement: measurements[measurementIndex],
      ),
    );
  }
}

class _MeasurementItem extends StatelessWidget {
  final HealthMeasurement measurement;

  const _MeasurementItem({
    required this.measurement,
  });

  @override
  Widget build(BuildContext context) {
    return Text(measurement.date.toString());
  }
}
