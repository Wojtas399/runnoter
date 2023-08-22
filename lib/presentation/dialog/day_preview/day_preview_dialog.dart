import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/day_preview/day_preview_bloc.dart';
import '../../../domain/entity/health_measurement.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/health_measurement_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/title_text_components.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../health_measurement_creator/health_measurement_creator_dialog.dart';
import 'day_preview_activities_content.dart';
import 'day_preview_add_activity_button.dart';

class DayPreviewDialog extends StatelessWidget {
  final String userId;
  final DateTime date;

  const DayPreviewDialog({super.key, required this.userId, required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DayPreviewBloc(userId: userId, date: date)
        ..add(const DayPreviewEventInitialize()),
      child: const BlocWithStatusListener<DayPreviewBloc, DayPreviewState,
          dynamic, dynamic>(
        child: ResponsiveLayout(
          mobileBody: _FullScreenDialog(),
          desktopBody: _NormalDialog(),
        ),
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
          child: Paddings24(
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

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final DateTime date = context.read<DayPreviewBloc>().date;

    return Text('${Str.of(context).day} ${date.toDateWithDots()}');
  }
}

class _HealthMeasurement extends StatelessWidget {
  const _HealthMeasurement();

  @override
  Widget build(BuildContext context) {
    final HealthMeasurement? measurement = context.select(
      (DayPreviewBloc bloc) => bloc.state.healthMeasurement,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleMedium(Str.of(context).dayPreviewHealthMeasurement),
            Row(
              children: [
                IconButton(
                  onPressed: () => _onEdit(context),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (measurement != null)
                  IconButton(
                    onPressed: () => _onDelete(measurement.date),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const Gap16(),
        HealthMeasurementInfo(healthMeasurement: measurement),
      ],
    );
  }

  Future<void> _onEdit(BuildContext context) async {
    await showDialogDependingOnScreenSize(HealthMeasurementCreatorDialog(
      date: context.read<DayPreviewBloc>().date,
    ));
  }

  void _onDelete(DateTime date) {
    //TODO
  }
}
