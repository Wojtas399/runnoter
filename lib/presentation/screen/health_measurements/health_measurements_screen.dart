import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/model/health_measurement.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/empty_content_info_component.dart';
import '../../formatter/date_formatter.dart';
import 'health_measurements_cubit.dart';

part 'health_measurements_item.dart';

class HealthMeasurementsScreen extends StatelessWidget {
  const HealthMeasurementsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Str.of(context).healthMeasurementsScreenTitle),
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
        child: CircularProgressIndicator(),
      );
    } else if (measurements.isEmpty) {
      return EmptyContentInfo(
        title: Str.of(context).healthMeasurementsNoMeasurementsInfo,
      );
    }
    return ListView.separated(
      itemCount: measurements.length,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemBuilder: (_, int measurementIndex) => _MeasurementItem(
        measurement: measurements[measurementIndex],
        isFirstItem: measurementIndex == 0,
      ),
      separatorBuilder: (_, int index) => const Divider(),
    );
  }
}
