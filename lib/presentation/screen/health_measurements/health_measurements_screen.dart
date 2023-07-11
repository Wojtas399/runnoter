import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/health_measurements/health_measurements_bloc.dart';
import '../../../domain/entity/health_measurement.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../config/ui_sizes.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';

part 'health_measurements_content.dart';
part 'health_measurements_item.dart';

class HealthMeasurementsScreen extends StatelessWidget {
  const HealthMeasurementsScreen({
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
