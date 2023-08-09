import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/cubit/mileage_cubit.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';

class MileageCharts extends StatelessWidget {
  final List<ChartYear> years;

  const MileageCharts({
    super.key,
    required this.years,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: years.length,
      padding: const EdgeInsets.all(24),
      itemBuilder: (_, int itemIndex) {
        final Widget chart = _Chart(yearData: years[itemIndex]);
        return ResponsiveLayout(
          mobileBody: chart,
          tabletBody: CardBody(child: chart),
          desktopBody: CardBody(child: chart),
        );
      },
      separatorBuilder: (_, int index) => const Gap32(),
    );
  }
}

class _Chart extends StatelessWidget {
  final ChartYear yearData;

  const _Chart({
    required this.yearData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleLarge('${yearData.year}'),
        const Gap16(),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(interval: 1),
          primaryYAxis: NumericAxis(
            title: AxisTitle(
              text:
                  '${Str.of(context).mileageChartMileage} [${context.distanceUnit.toUIShortFormat()}]',
              textStyle: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          series: <ColumnSeries<ChartMonth, String>>[
            ColumnSeries(
              dataSource: yearData.months,
              xValueMapper: (ChartMonth point, _) => DateTime(
                yearData.year,
                point.month.monthNumber,
              ).toMonthAbbreviation(context),
              yValueMapper: (ChartMonth point, _) =>
                  context.convertDistanceFromDefaultUnit(point.mileage),
            ),
          ],
        ),
      ],
    );
  }
}
