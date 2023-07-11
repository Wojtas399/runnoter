import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/date_selector_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../component/text_field_component.dart';
import '../../config/ui_sizes.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'health_measurement_creator_content.dart';
part 'health_measurement_creator_form.dart';

class HealthMeasurementCreatorDialog extends StatelessWidget {
  final DateTime? date;

  const HealthMeasurementCreatorDialog({
    super.key,
    this.date,
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
        navigateBack();
        showSnackbarMessage(
          str.healthMeasurementCreatorSuccessfullyAddedMeasurement,
        );
        break;
      case HealthMeasurementCreatorBlocInfo.measurementUpdated:
        navigateBack();
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
