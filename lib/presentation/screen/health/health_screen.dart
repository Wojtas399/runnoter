import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../../domain/service/health_chart_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import 'health_content.dart';

@RoutePage()
class HealthScreen extends StatelessWidget {
  const HealthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: HealthContent(),
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
      create: (BuildContext context) => HealthBloc(
        dateService: DateService(),
        authService: context.read<AuthService>(),
        healthMeasurementRepository:
            context.read<HealthMeasurementRepository>(),
        chartService: HealthChartService(
          dateService: DateService(),
        ),
      )..add(
          const HealthEventInitialize(),
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
    return BlocWithStatusListener<HealthBloc, HealthState, HealthBlocInfo,
        dynamic>(
      onInfo: (HealthBlocInfo info) => _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, HealthBlocInfo info) {
    if (info == HealthBlocInfo.healthMeasurementDeleted) {
      showSnackbarMessage(Str.of(context).healthSuccessfullyDeletedMeasurement);
    }
  }
}
