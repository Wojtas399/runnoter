import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/health_measurement_creator/health_measurement_creator_bloc.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/label_text_components.dart';
import '../../config/body_sizes.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import 'health_measurement_creator_form.dart';

class HealthMeasurementCreatorContent extends StatelessWidget {
  const HealthMeasurementCreatorContent({super.key});

  @override
  Widget build(BuildContext context) => const ResponsiveLayout(
        mobileBody: _FullScreenDialogContent(),
        desktopBody: _NormalDialogContent(),
      );
}

class _NormalDialogContent extends StatelessWidget {
  const _NormalDialogContent();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    return AlertDialog(
      title: Text(str.healthMeasurementCreatorScreenTitle),
      content: GestureDetector(
        onTap: unfocusInputs,
        child: SizedBox(
          width: GetIt.I.get<BodySizes>().smallBodyWidth,
          child: const _Form(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: LabelLarge(
            str.cancel,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const _SubmitButton(),
      ],
    );
  }
}

class _FullScreenDialogContent extends StatelessWidget {
  const _FullScreenDialogContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Str.of(context).healthMeasurementCreatorScreenTitle),
        leading: const CloseButton(),
        actions: const [
          _SubmitButton(),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: unfocusInputs,
          child: const Paddings24(
            child: _Form(),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (HealthMeasurementCreatorBloc bloc) => bloc.state.status,
    );

    if (blocStatus is BlocStatusInitial) {
      return const LoadingInfo();
    }
    return const HealthMeasurementCreatorForm();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (HealthMeasurementCreatorBloc bloc) => !bloc.state.canSubmit,
    );
    final String label = Str.of(context).save;

    return FilledButton(
      onPressed: isDisabled ? null : () => _onPressed(context),
      child: Text(label),
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<HealthMeasurementCreatorBloc>().add(
          const HealthMeasurementCreatorEventSubmit(),
        );
  }
}
