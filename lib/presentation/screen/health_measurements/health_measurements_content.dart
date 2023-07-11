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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: bigContentWidth),
            child: const _Body(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddButtonPressed(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onAddButtonPressed(BuildContext context) async =>
      await showHealthMeasurementCreatorDialog(context: context);
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final List<HealthMeasurement>? measurements = context.select(
      (HealthMeasurementsBloc bloc) => bloc.state.measurements,
    );

    return switch (measurements) {
      null => const LoadingInfo(),
      [] => EmptyContentInfo(
          title: Str.of(context).healthMeasurementsNoMeasurementsInfo,
        ),
      [...] => _Measurements(measurements: measurements),
    };
  }
}

class _Measurements extends StatelessWidget {
  final List<HealthMeasurement> measurements;

  const _Measurements({
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) {
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
