import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/health_measurements_cubit.dart';
import '../../../domain/entity/health_measurement.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/label_text_components.dart';
import '../../feature/dialog/health_measurement_creator/health_measurement_creator_dialog.dart';
import '../../service/dialog_service.dart';
import 'health_measurements_item.dart';

class HealthMeasurementsContent extends StatelessWidget {
  const HealthMeasurementsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text(Str.of(context).healthMeasurementsTitle),
      ),
      body: const SafeArea(
        child: MediumBody(
          child: Column(
            children: [
              _Header(),
              Expanded(
                child: _Body(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonPressed,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onAddButtonPressed() async =>
      await showDialogDependingOnScreenSize(
        const HealthMeasurementCreatorDialog(),
      );
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final List<HealthMeasurement>? measurements = context.select(
      (HealthMeasurementsCubit cubit) => cubit.state,
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
                    str.restingHeartRate,
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
                    str.fastingWeight,
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

  const _Measurements({required this.measurements});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: measurements.length,
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemBuilder: (_, int measurementIndex) => HealthMeasurementsItem(
        measurement: measurements[measurementIndex],
        isFirstItem: measurementIndex == 0,
      ),
      separatorBuilder: (_, int index) => const Divider(),
    );
  }
}
