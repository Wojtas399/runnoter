part of 'health_measurements_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text(Str.of(context).healthMeasurementsTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: bigContentWidth),
            child: const Column(
              children: [
                _Header(),
                Expanded(
                  child: _Body(),
                ),
              ],
            ),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    const FontWeight fontWeight = FontWeight.bold;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: LabelLarge(
                    str.date,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: LabelLarge(
                    str.healthRestingHeartRate,
                    textAlign: TextAlign.center,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: LabelLarge(
                    str.healthFastingWeight,
                    textAlign: TextAlign.center,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
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
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemBuilder: (_, int measurementIndex) => _MeasurementItem(
        measurement: measurements[measurementIndex],
        isFirstItem: measurementIndex == 0,
      ),
      separatorBuilder: (_, int index) => const Divider(),
    );
  }
}
