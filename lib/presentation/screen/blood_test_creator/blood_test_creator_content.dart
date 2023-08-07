import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/blood_test_creator/blood_test_creator_bloc.dart';
import '../../../domain/entity/blood_parameter.dart';
import '../../../domain/entity/user.dart';
import '../../component/blood_parameter_results_list_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/date_selector_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/title_text_components.dart';
import '../../service/dialog_service.dart';
import '../../service/utils.dart';
import 'blood_test_creator_app_bar.dart';

class BloodTestCreatorContent extends StatelessWidget {
  const BloodTestCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges:
              context.read<BloodTestCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: const BloodTestCreatorAppBar(),
        body: SafeArea(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: const MediumBody(
              child: Column(
                children: [
                  _DateSection(),
                  Expanded(child: _ParametersSection()),
                ],
              ),
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
      (BloodTestCreatorBloc bloc) => bloc.state.date,
    );

    return DateSelector(
      date: date,
      lastDate: DateTime.now(),
      onDateSelected: (DateTime date) => _onDateSelected(context, date),
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    context.read<BloodTestCreatorBloc>().add(
          BloodTestCreatorEventDateChanged(date: date),
        );
  }
}

class _ParametersSection extends StatelessWidget {
  const _ParametersSection();

  @override
  Widget build(BuildContext context) {
    final Gender? gender = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.gender,
    );
    final List<BloodParameterResult>? parameterResults = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.parameterResults,
    );

    return gender == null
        ? const CircularProgressIndicator()
        : BloodParameterResultsList(
            isEditMode: true,
            gender: gender,
            parameterResults: parameterResults,
            onParameterValueChanged: (
              BloodParameter parameter,
              double? value,
            ) =>
                _onValueChanged(context, parameter, value),
          );
  }

  void _onValueChanged(
    BuildContext context,
    BloodParameter parameter,
    double? value,
  ) {
    context.read<BloodTestCreatorBloc>().add(
          BloodTestCreatorEventParameterResultChanged(
            parameter: parameter,
            value: value,
          ),
        );
  }
}
