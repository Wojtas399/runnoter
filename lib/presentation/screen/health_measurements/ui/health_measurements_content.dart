part of 'health_measurements_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Str.of(context).healthMeasurementsScreenTitle),
      ),
      body: const SafeArea(
        child: _Measurements(),
      ),
    );
  }
}

class _Measurements extends StatelessWidget {
  const _Measurements();

  @override
  Widget build(BuildContext context) {
    final List<HealthMeasurement>? measurements = context.select(
      (HealthMeasurementsBloc bloc) => bloc.state.measurements,
    );

    if (measurements == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (measurements.isEmpty) {
      return EmptyContentInfo(
        title: Str.of(context).healthMeasurementsNoMeasurementsInfo,
      );
    }
    return ListView.separated(
      itemCount: measurements.length,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemBuilder: (_, int measurementIndex) => _MeasurementItem(
        measurement: measurements[measurementIndex],
        isFirstItem: measurementIndex == 0,
      ),
      separatorBuilder: (_, int index) => const Divider(),
    );
  }
}