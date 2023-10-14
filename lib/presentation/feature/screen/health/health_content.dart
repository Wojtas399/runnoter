import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/health_measurement.dart';
import '../../../../domain/cubit/today_measurement_cubit.dart';
import '../../../component/big_button_component.dart';
import '../../../component/body/big_body_component.dart';
import '../../../component/card_body_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/health_measurement_info_component.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../config/navigation/router.dart';
import '../../../feature/dialog/health_measurement_creator/health_measurement_creator_dialog.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'health_charts.dart';

class HealthContent extends StatelessWidget {
  const HealthContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: BigBody(
        child: ResponsiveLayout(
          mobileBody: _MobileContent(),
          desktopBody: _DesktopContent(),
        ),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 144),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TodayMeasurement(),
          Gap24(),
          HealthCharts(),
          Gap24(),
          _ShowAllMeasurementsButton(),
        ],
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Paddings24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardBody(
            child: _TodayMeasurement(),
          ),
          Gap16(),
          CardBody(
            child: HealthCharts(),
          ),
          Gap16(),
          _ShowAllMeasurementsButton(),
        ],
      ),
    );
  }
}

class _TodayMeasurement extends StatelessWidget {
  const _TodayMeasurement();

  @override
  Widget build(BuildContext context) {
    final HealthMeasurement? todayMeasurement = context.select(
      (TodayMeasurementCubit cubit) => cubit.state,
    );

    return HealthMeasurementInfo(
      label: Str.of(context).healthTodayMeasurement,
      healthMeasurement: todayMeasurement,
      displayBigButtonIfHealthMeasurementIsNull: true,
      onEdit: _onEdit,
      onDelete: () => _onDelete(context),
    );
  }

  Future<void> _onEdit() async {
    await showDialogDependingOnScreenSize(
      HealthMeasurementCreatorDialog(date: DateTime.now()),
    );
  }

  Future<void> _onDelete(BuildContext context) async {
    final todayMeasurementCubit = context.read<TodayMeasurementCubit>();
    final str = Str.of(context);
    final bool isConfirmed = await askForConfirmation(
      title: Text(str.deleteHealthMeasurementConfirmationDialogTitle),
      content: Text(str.deleteHealthMeasurementConfirmationDialogMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
    if (isConfirmed) {
      showLoadingDialog();
      await todayMeasurementCubit.deleteTodayMeasurement();
      closeLoadingDialog();
      showSnackbarMessage(str.successfullyDeletedMeasurement);
    }
  }
}

class _ShowAllMeasurementsButton extends StatelessWidget {
  const _ShowAllMeasurementsButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          label: Str.of(context).healthShowAllMeasurementsButton,
          onPressed: _onPressed,
        ),
      ],
    );
  }

  void _onPressed() {
    navigateTo(const HealthMeasurementsRoute());
  }
}
