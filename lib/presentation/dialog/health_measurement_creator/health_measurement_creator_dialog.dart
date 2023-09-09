import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/health_measurement_creator/health_measurement_creator_cubit.dart';
import '../../component/cubit_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'health_measurement_creator_content.dart';

class HealthMeasurementCreatorDialog extends StatelessWidget {
  final DateTime? date;

  const HealthMeasurementCreatorDialog({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HealthMeasurementCreatorCubit()..initialize(date),
      child: const _CubitListener(
        child: HealthMeasurementCreatorContent(),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<
        HealthMeasurementCreatorCubit,
        HealthMeasurementCreatorState,
        HealthMeasurementCreatorCubitInfo,
        HealthMeasurementCreatorCubitError>(
      onInfo: (HealthMeasurementCreatorCubitInfo info) {
        _manageInfo(context, info);
      },
      onError: (HealthMeasurementCreatorCubitError error) {
        _manageError(context, error);
      },
      child: child,
    );
  }

  void _manageInfo(
    BuildContext context,
    HealthMeasurementCreatorCubitInfo info,
  ) {
    final str = Str.of(context);
    switch (info) {
      case HealthMeasurementCreatorCubitInfo.measurementAdded:
        popRoute();
        showSnackbarMessage(
          str.healthMeasurementCreatorSuccessfullyAddedMeasurement,
        );
        break;
      case HealthMeasurementCreatorCubitInfo.measurementUpdated:
        popRoute();
        showSnackbarMessage(
          str.healthMeasurementCreatorSuccessfullyUpdatedMeasurement,
        );
        break;
    }
  }

  void _manageError(
    BuildContext context,
    HealthMeasurementCreatorCubitError error,
  ) {
    final str = Str.of(context);
    switch (error) {
      case HealthMeasurementCreatorCubitError
            .measurementWithSelectedDateAlreadyExist:
        showMessageDialog(
          title: str.healthMeasurementCreatorAlreadyAddedMeasurementTitle,
          message: str.healthMeasurementCreatorAlreadyAddedMeasurementMessage,
        );
        break;
    }
  }
}
