import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/date_service.dart';
import '../../../../domain/repository/health_measurement_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../model/bloc_status.dart';
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
      child: const _Content(),
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
