import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/mileage_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import 'mileage_charts.dart';

class MileageContent extends StatelessWidget {
  const MileageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const BigBody(
      child: _Charts(),
    );
  }
}

class _Charts extends StatelessWidget {
  const _Charts();

  @override
  Widget build(BuildContext context) {
    final List<ChartYear>? years = context.select(
      (MileageCubit cubit) => cubit.state,
    );

    return switch (years) {
      null => const LoadingInfo(),
      [] => const _NoDataInfo(),
      [...] => MileageCharts(years: years),
    };
  }
}

class _NoDataInfo extends StatelessWidget {
  const _NoDataInfo();

  @override
  Widget build(BuildContext context) {
    return Paddings24(
      child: EmptyContentInfo(
        icon: Icons.insert_chart_outlined,
        title: Str.of(context).mileageNoDataTitle,
        subtitle: Str.of(context).mileageNoDataMessage,
      ),
    );
  }
}
