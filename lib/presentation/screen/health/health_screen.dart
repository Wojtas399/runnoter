import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common/date_service.dart';
import '../../../domain/bloc/health/health_bloc.dart';
import '../../../domain/entity/health_measurement.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../../domain/service/health_chart_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/routes.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'health_chart_range_selection.dart';
part 'health_charts.dart';
part 'health_content.dart';
part 'health_today_measurement.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: _Content(),
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
      child: child,
    );
  }
}
