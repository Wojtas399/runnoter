part of 'mileage_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final List<ChartYear>? years = context.select(
      (MileageCubit cubit) => cubit.state,
    );

    return switch (years) {
      null => const LoadingInfo(),
      [] => const _NoDataInfo(),
      [...] => _Charts(years: years),
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
