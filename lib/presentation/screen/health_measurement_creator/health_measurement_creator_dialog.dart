import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'health_measurement_creator_content.dart';

class HealthMeasurementCreatorDialog extends StatelessWidget {
  final DateTime? date;

  const HealthMeasurementCreatorDialog({
    super.key,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HealthMeasurementCreatorBloc(date: date)
        ..add(const HealthMeasurementCreatorEventInitialize()),
      child: const _BlocListener(
        child: HealthMeasurementCreatorContent(),
      ),
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
        HealthMeasurementCreatorBlocError>(
      onInfo: (HealthMeasurementCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      onError: (HealthMeasurementCreatorBlocError error) {
        _manageError(context, error);
      },
      child: child,
    );
  }

  void _manageInfo(
    BuildContext context,
    HealthMeasurementCreatorBlocInfo info,
  ) {
    final str = Str.of(context);
    switch (info) {
      case HealthMeasurementCreatorBlocInfo.measurementAdded:
        popRoute();
        showSnackbarMessage(
          str.healthMeasurementCreatorSuccessfullyAddedMeasurement,
        );
        break;
      case HealthMeasurementCreatorBlocInfo.measurementUpdated:
        popRoute();
        showSnackbarMessage(
          str.healthMeasurementCreatorSuccessfullyUpdatedMeasurement,
        );
        break;
    }
  }

  void _manageError(
    BuildContext context,
    HealthMeasurementCreatorBlocError error,
  ) {
    final str = Str.of(context);
    switch (error) {
      case HealthMeasurementCreatorBlocError
            .measurementWithSelectedDateAlreadyExist:
        showMessageDialog(
          title: str.healthMeasurementCreatorAlreadyAddedMeasurementTitle,
          message: str.healthMeasurementCreatorAlreadyAddedMeasurementMessage,
        );
        break;
    }
  }
}
