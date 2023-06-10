part of 'mileage_screen.dart';

class _Charts extends StatelessWidget {
  const _Charts();

  @override
  Widget build(BuildContext context) {
    final List<ChartYear>? years = context.select(
      (MileageCubit cubit) => cubit.state,
    );

    if (years == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (years.isEmpty) {
      return Paddings24(
        child: EmptyContentInfo(
          icon: Icons.insert_chart_outlined,
          title: Str.of(context).mileageNoDataTitle,
          subtitle: Str.of(context).mileageNoDataMessage,
        ),
      );
    }
    return ListView.separated(
      itemCount: years.length,
      padding: const EdgeInsets.fromLTRB(8, 24, 24, 24),
      itemBuilder: (_, int itemIndex) {
        final ChartYear yearData = years[itemIndex];
        return Column(
          children: [
            TitleLarge('${yearData.year}'),
            const SizedBox(height: 16),
            _YearChart(yearData: yearData),
          ],
        );
      },
      separatorBuilder: (_, int index) => const SizedBox(height: 32),
    );
  }
}

class _YearChart extends StatelessWidget {
  final ChartYear yearData;

  const _YearChart({
    required this.yearData,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        interval: 1,
      ),
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
    );
  }
}
