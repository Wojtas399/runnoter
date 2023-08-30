import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../service/dialog_service.dart';
import 'activity_status_creator_params_form.dart';
import 'activity_status_creator_status_type.dart';

class ActivityStatusCreatorContent extends StatelessWidget {
  const ActivityStatusCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await askForConfirmationToLeave(
        areUnsavedChanges:
            context.read<ActivityStatusCreatorBloc>().state.canSubmit,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Str.of(context).activityStatus),
          centerTitle: true,
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: MediumBody(
              child: Paddings24(
                child: Column(
                  children: [
                    ActivityStatusCreatorStatusType(),
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
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final ActivityStatusType? activityStatusType = context.select(
      (ActivityStatusCreatorBloc bloc) => bloc.state.activityStatusType,
    );

    return activityStatusType == ActivityStatusType.done ||
            activityStatusType == ActivityStatusType.aborted
        ? const ActivityStatusCreatorParamsForm()
        : const SizedBox();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ActivityStatusCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return BigButton(
      label: Str.of(context).save,
      isDisabled: isDisabled,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<ActivityStatusCreatorBloc>().add(
          const ActivityStatusCreatorEventSubmit(),
        );
  }
}
