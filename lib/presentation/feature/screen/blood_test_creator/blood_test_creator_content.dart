import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/additional_model/blood_parameter.dart';
import '../../../../data/entity/user.dart';
import '../../../../domain/cubit/blood_test_creator/blood_test_creator_cubit.dart';
import '../../../component/blood_parameter_results_list_component.dart';
import '../../../component/body/medium_body_component.dart';
import '../../../component/date_selector_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../service/dialog_service.dart';
import 'blood_test_creator_app_bar.dart';

class BloodTestCreatorContent extends StatelessWidget {
  const BloodTestCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await askForConfirmationToLeave(
        areUnsavedChanges:
            context.read<BloodTestCreatorCubit>().state.canSubmit,
      ),
      child: const Scaffold(
        appBar: BloodTestCreatorAppBar(),
        body: SafeArea(
          child: MediumBody(
            child: Column(
              children: [
                _DateSection(),
                Expanded(child: _ParametersSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleMedium(Str.of(context).date),
          const Gap8(),
          const _DateValue(),
        ],
      ),
    );
  }
}

class _DateValue extends StatelessWidget {
  const _DateValue();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestCreatorCubit cubit) => cubit.state.date,
    );

    return DateSelector(
      date: date,
      lastDate: DateTime.now(),
      onDateSelected: context.read<BloodTestCreatorCubit>().dateChanged,
    );
  }
}

class _ParametersSection extends StatelessWidget {
  const _ParametersSection();

  @override
  Widget build(BuildContext context) {
    final Gender? gender = context.select(
      (BloodTestCreatorCubit cubit) => cubit.state.gender,
    );
    final List<BloodParameterResult>? parameterResults = context.select(
      (BloodTestCreatorCubit cubit) => cubit.state.parameterResults,
    );

    return gender == null
        ? const LoadingInfo()
        : BloodParameterResultsList(
            isEditMode: true,
            gender: gender,
            parameterResults: parameterResults,
            onParameterValueChanged: (
              BloodParameter parameter,
              double? value,
            ) =>
                context.read<BloodTestCreatorCubit>().parameterValueChanged(
                      parameter: parameter,
                      value: value,
                    ),
            onSubmitted: () => _onSubmitted(context),
          );
  }

  void _onSubmitted(BuildContext context) {
    final cubit = context.read<BloodTestCreatorCubit>();
    if (cubit.state.canSubmit) cubit.submit();
  }
}
