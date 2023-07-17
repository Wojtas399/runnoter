import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../component/big_button_component.dart';
import '../../component/card_body_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/body_sizes.dart';
import '../../config/navigation/router.dart';
import '../../service/navigator_service.dart';
import 'health_charts_section.dart';
import 'health_today_measurement_section.dart';

class HealthContent extends StatelessWidget {
  const HealthContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: GetIt.I.get<BodySizes>().bigBodyWidth,
          ),
          child: const ResponsiveLayout(
            mobileBody: _MobileContent(),
            tabletBody: _DesktopContent(),
            desktopBody: _DesktopContent(),
          ),
        ),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    const SizedBox gap = SizedBox(height: 24);

    return const Paddings24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthTodayMeasurementSection(),
          gap,
          HealthChartsSection(),
          gap,
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
    const SizedBox gap = SizedBox(height: 16);

    return const Padding(
      padding: EdgeInsets.only(right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardBody(child: HealthTodayMeasurementSection()),
          gap,
          CardBody(child: HealthChartsSection()),
          gap,
          _ShowAllMeasurementsButton(),
        ],
      ),
    );
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
