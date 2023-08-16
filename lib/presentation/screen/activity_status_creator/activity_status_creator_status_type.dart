import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/activity_status.dart';
import '../../../domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../formatter/activity_status_formatter.dart';

class ActivityStatusCreatorStatusType extends StatelessWidget {
  const ActivityStatusCreatorStatusType({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivityStatusType? activityStatusType = context.select(
      (ActivityStatusCreatorBloc bloc) => bloc.state.activityStatusType,
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
      onChanged: (ActivityStatusType? statusType) =>
          _onChanged(context, statusType),
    );
  }

  void _onChanged(
    BuildContext context,
    ActivityStatusType? activityStatusType,
  ) {
    context.read<ActivityStatusCreatorBloc>().add(
          ActivityStatusCreatorEventActivityStatusTypeChanged(
            activityStatusType: activityStatusType,
          ),
        );
  }
}

class _ActivityStatusDescription extends StatelessWidget {
  final ActivityStatusType statusType;

  const _ActivityStatusDescription({
    required this.statusType,
  });

  @override
  Widget build(BuildContext context) {
    ActivityStatus? status;
    switch (statusType) {
      case ActivityStatusType.pending:
        status = const ActivityStatusPending();
        break;
      case ActivityStatusType.done:
        status = const ActivityStatusDone(
          coveredDistanceInKm: 0,
          avgPace: Pace(minutes: 0, seconds: 0),
          avgHeartRate: 0,
          moodRate: MoodRate.mr1,
          comment: '',
        );
        break;
      case ActivityStatusType.aborted:
        status = const ActivityStatusAborted(
          coveredDistanceInKm: 0,
          avgPace: Pace(minutes: 0, seconds: 0),
          avgHeartRate: 0,
          moodRate: MoodRate.mr1,
          comment: '',
        );
        break;
      case ActivityStatusType.undone:
        status = const ActivityStatusUndone();
        break;
    }

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
}
