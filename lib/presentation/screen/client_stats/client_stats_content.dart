import 'package:flutter/material.dart';

import '../../component/body/big_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import 'client_stats_health.dart';
import 'client_stats_mileage.dart';

class ClientStatsContent extends StatelessWidget {
  const ClientStatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: ResponsiveLayout(
        mobileBody: _MobileContent(),
        desktopBody: _DesktopContent(),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Paddings24(
      child: Column(
        children: [
          ClientStatsMileage(),
          Gap16(),
          ClientStatsHealth(),
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
              child: ClientStatsMileage(),
            ),
            Gap16(),
            CardBody(
              child: ClientStatsHealth(),
            ),
          ],
        ),
      ),
    );
  }
}
