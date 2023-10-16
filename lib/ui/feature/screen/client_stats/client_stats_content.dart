import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/body/big_body_component.dart';
import '../../../component/card_body_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../cubit/health_stats/health_stats_cubit.dart';
import '../../../cubit/mileage_stats/mileage_stats_cubit.dart';
import 'client_stats_health.dart';
import 'client_stats_mileage.dart';

class ClientStatsContent extends StatelessWidget {
  const ClientStatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _onRefresh(context),
      child: const SingleChildScrollView(
        child: ResponsiveLayout(
          mobileBody: _MobileContent(),
          desktopBody: _DesktopContent(),
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final mileageStatsCubit = context.read<MileageStatsCubit>();
    final healthStatsCubit = context.read<HealthStatsCubit>();
    await mileageStatsCubit.refresh();
    await healthStatsCubit.refresh();
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 144),
      child: Column(
        children: [
          ClientStatsHealth(),
          Gap16(),
          ClientStatsMileage(),
        ],
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const BigBody(
      child: Paddings24(
        child: Column(
          children: [
            CardBody(
              child: ClientStatsHealth(),
            ),
            Gap16(),
            CardBody(
              child: ClientStatsMileage(),
            ),
          ],
        ),
      ),
    );
  }
}
