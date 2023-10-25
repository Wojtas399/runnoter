import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/model/activity.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../cubit/activity_status_creator/activity_status_creator_cubit.dart';
import '../../formatter/activity_status_formatter.dart';
import '../../service/dialog_service.dart';
import 'activity_status_creator_params_form.dart';

class ActivityStatusCreatorContent extends StatelessWidget {
  const ActivityStatusCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await askForConfirmationToLeave(
        areUnsavedChanges:
            context.read<ActivityStatusCreatorCubit>().state.canSubmit,
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
                    _StatusType(),
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

class _StatusType extends StatelessWidget {
  const _StatusType();

  @override
  Widget build(BuildContext context) {
    final ActivityStatusType? activityStatusType = context.select(
      (ActivityStatusCreatorCubit cubit) => cubit.state.activityStatusType,
    );

    return DropdownButtonFormField<ActivityStatusType>(
      value: activityStatusType,
      decoration: InputDecoration(labelText: Str.of(context).activityStatus),
      items: <DropdownMenuItem<ActivityStatusType>>[
        ...ActivityStatusType.values.map(
          (ActivityStatusType statusType) => DropdownMenuItem(
            value: statusType,
            child: _ActivityStatusDescription(statusType: statusType),
          ),
        ),
      ],
      onChanged:
          context.read<ActivityStatusCreatorCubit>().activityStatusTypeChanged,
    );
  }
}

class _ActivityStatusDescription extends StatelessWidget {
  final ActivityStatusType statusType;

  const _ActivityStatusDescription({required this.statusType});

  @override
  Widget build(BuildContext context) {
    ActivityStatus status = switch (statusType) {
      ActivityStatusType.pending => const ActivityStatusPending(),
      ActivityStatusType.done => _createFakeDoneStatus(),
      ActivityStatusType.aborted => _createFakeAbortedStatus(),
      ActivityStatusType.undone => const ActivityStatusUndone(),
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          status.toIcon(),
          size: 20,
          color: status.toColor(context),
        ),
        const GapHorizontal8(),
        Text(
          status.toLabel(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: status.toColor(context),
              ),
        ),
      ],
    );
  }

  ActivityStatusDone _createFakeDoneStatus() => const ActivityStatusDone(
        coveredDistanceInKm: 0,
        avgPace: Pace(minutes: 0, seconds: 0),
        avgHeartRate: 0,
        moodRate: MoodRate.mr1,
        comment: '',
      );

  ActivityStatusAborted _createFakeAbortedStatus() =>
      const ActivityStatusAborted(
        coveredDistanceInKm: 0,
        avgPace: Pace(minutes: 0, seconds: 0),
        avgHeartRate: 0,
        moodRate: MoodRate.mr1,
        comment: '',
      );
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final ActivityStatusType? activityStatusType = context.select(
      (ActivityStatusCreatorCubit cubit) => cubit.state.activityStatusType,
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
      (ActivityStatusCreatorCubit cubit) => !cubit.state.canSubmit,
    );

    return BigButton(
      label: Str.of(context).save,
      isDisabled: isDisabled,
      onPressed: context.read<ActivityStatusCreatorCubit>().submit,
    );
  }
}
