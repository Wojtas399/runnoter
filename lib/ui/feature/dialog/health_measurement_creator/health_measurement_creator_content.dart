import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/gap/gap_horizontal_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../component/text/label_text_components.dart';
import '../../../cubit/health_measurement_creator/health_measurement_creator_cubit.dart';
import '../../../model/cubit_status.dart';
import '../../../service/navigator_service.dart';
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
      content: const SizedBox(
        width: 500,
        child: _Form(),
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
          GapHorizontal16(),
        ],
      ),
      body: const SafeArea(
        child: Paddings24(
          child: _Form(),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final CubitStatus cubitStatus = context.select(
      (HealthMeasurementCreatorCubit cubit) => cubit.state.status,
    );

    return cubitStatus is CubitStatusInitial
        ? const LoadingInfo()
        : const HealthMeasurementCreatorForm();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (HealthMeasurementCreatorCubit cubit) => !cubit.state.canSubmit,
    );
    final String label = Str.of(context).save;

    return FilledButton(
      onPressed: isDisabled
          ? null
          : context.read<HealthMeasurementCreatorCubit>().submit,
      child: Text(label),
    );
  }
}
