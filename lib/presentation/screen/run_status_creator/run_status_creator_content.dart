import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/gap_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../service/dialog_service.dart';
import '../../service/utils.dart';
import 'run_status_creator_params_form.dart';
import 'run_status_creator_status_type.dart';

class RunStatusCreatorContent extends StatelessWidget {
  const RunStatusCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges:
              context.read<RunStatusCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Str.of(context).runStatusCreatorScreenTitle),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: unfocusInputs,
              child: const MediumBody(
                child: Paddings24(
                  child: Column(
                    children: [
                      RunStatusCreatorStatusType(),
                      Gap24(),
                      _Form(),
                      Gap24(),
                      _SubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
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
    final RunStatusType? runStatusType = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.runStatusType,
    );

    return runStatusType == RunStatusType.done ||
            runStatusType == RunStatusType.aborted
        ? const RunStatusCreatorParamsForm()
        : const SizedBox();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (RunStatusCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return BigButton(
      label: Str.of(context).save,
      isDisabled: isDisabled,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<RunStatusCreatorBloc>().add(
          const RunStatusCreatorEventSubmit(),
        );
  }
}
