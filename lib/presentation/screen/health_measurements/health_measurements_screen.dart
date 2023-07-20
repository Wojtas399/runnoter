import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/health_measurements/health_measurements_bloc.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import 'health_measurements_content.dart';

@RoutePage()
class HealthMeasurementsScreen extends StatelessWidget {
  const HealthMeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: HealthMeasurementsContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HealthMeasurementsBloc(
        authService: context.read<AuthService>(),
        healthMeasurementRepository:
            context.read<HealthMeasurementRepository>(),
      )..add(
          const HealthMeasurementsEventInitialize(),
        ),
      child: child,
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<HealthMeasurementsBloc,
        HealthMeasurementsState, HealthMeasurementsBlocInfo, dynamic>(
      onInfo: (HealthMeasurementsBlocInfo info) {
        _manageBlocInfo(context, info);
      },
      child: child,
    );
  }

  void _manageBlocInfo(
    BuildContext context,
    HealthMeasurementsBlocInfo info,
  ) {
    switch (info) {
      case HealthMeasurementsBlocInfo.measurementDeleted:
        showSnackbarMessage(
          Str.of(context).healthMeasurementsDeletedMeasurementMessage,
        );
        break;
    }
  }
}
