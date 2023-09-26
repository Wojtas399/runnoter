import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/day_preview/day_preview_cubit.dart';
import '../../../domain/entity/health_measurement.dart';
import '../../component/gap/gap_components.dart';
import '../../component/health_measurement_info_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/title_text_components.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../health_measurement_creator/health_measurement_creator_dialog.dart';
import 'day_preview_activities_content.dart';
import 'day_preview_add_activity_button.dart';

//TODO: Activities content is loading infinitely

class DayPreviewDialog extends StatelessWidget {
  final String userId;
  final DateTime date;

  const DayPreviewDialog({super.key, required this.userId, required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DayPreviewCubit(userId: userId, date: date)..initialize(),
      child: const ResponsiveLayout(
        mobileBody: _FullScreenDialog(),
        desktopBody: _NormalDialog(),
      ),
    );
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const gap = Gap24();

    return AlertDialog(
      title: const _Title(),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HealthMeasurement(),
              gap,
              TitleMedium(Str.of(context).dayPreviewActivities),
              gap,
              const DayPreviewAddActivityButton(),
              gap,
              const DayPreviewActivities(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: Text(str.close),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog();

  @override
  Widget build(BuildContext context) {
    const gap = Gap24();

    return Scaffold(
      appBar: const _AppBar(),
      floatingActionButton: const DayPreviewAddActivityButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _BodyPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HealthMeasurement(),
                gap,
                TitleMedium(Str.of(context).dayPreviewActivities),
                gap,
                const DayPreviewActivities(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const _Title(),
      leading: const CloseButton(),
    );
  }
}

class _BodyPadding extends StatelessWidget {
  final Widget child;

  const _BodyPadding({required this.child});

  @override
  Widget build(BuildContext context) {
    final bool canModifyHealthMeasurement = context.select(
      (DayPreviewCubit cubit) => cubit.state.canModifyHealthMeasurement,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        canModifyHealthMeasurement ? 12 : 24,
        24,
        24,
      ),
      child: child,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final DateTime date = context.read<DayPreviewCubit>().date;

    return Text('${Str.of(context).day} ${date.toDateWithDots()}');
  }
}

class _HealthMeasurement extends StatelessWidget {
  const _HealthMeasurement();

  @override
  Widget build(BuildContext context) {
    final bool canModify = context.select(
      (DayPreviewCubit cubit) => cubit.state.canModifyHealthMeasurement,
    );
    final HealthMeasurement? measurement = context.select(
      (DayPreviewCubit cubit) => cubit.state.healthMeasurement,
    );

    return HealthMeasurementInfo(
      label: Str.of(context).healthMeasurement,
      healthMeasurement: measurement,
      displayBigButtonIfHealthMeasurementIsNull: true,
      onEdit: canModify ? () => _onEdit(context) : null,
      onDelete: canModify ? () => _onRemove(context) : null,
    );
  }

  Future<void> _onEdit(BuildContext context) async {
    await showDialogDependingOnScreenSize(HealthMeasurementCreatorDialog(
      date: context.read<DayPreviewCubit>().date,
    ));
  }

  Future<void> _onRemove(BuildContext context) async {
    showLoadingDialog();
    await context.read<DayPreviewCubit>().removeHealthMeasurement();
    closeLoadingDialog();
  }
}
