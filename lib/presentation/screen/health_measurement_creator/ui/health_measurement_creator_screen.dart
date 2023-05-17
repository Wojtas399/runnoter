import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/big_button_component.dart';
import '../../../component/bloc_with_status_listener_component.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/date_formatter.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../model/bloc_status.dart';
import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../bloc/health_measurement_creator_bloc.dart';

part 'health_measurement_creator_content.dart';

class HealthMeasurementCreatorScreen extends StatelessWidget {
  final DateTime? date;

  const HealthMeasurementCreatorScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      date: date,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final DateTime? date;
  final Widget child;

  const _BlocProvider({
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HealthMeasurementCreatorBloc(
        dateService: DateService(),
        authService: context.read<AuthService>(),
        healthMeasurementRepository:
            context.read<HealthMeasurementRepository>(),
      )..add(
          HealthMeasurementCreatorEventInitialize(date: date),
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
    return BlocWithStatusListener<
        HealthMeasurementCreatorBloc,
        HealthMeasurementCreatorState,
        HealthMeasurementCreatorBlocInfo,
        dynamic>(
      onInfo: (HealthMeasurementCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(
    BuildContext context,
    HealthMeasurementCreatorBlocInfo info,
  ) {
    switch (info) {
      case HealthMeasurementCreatorBlocInfo.measurementLoaded:
        break;
      case HealthMeasurementCreatorBlocInfo.measurementSaved:
        navigateBack(context: context);
        break;
    }
  }
}
