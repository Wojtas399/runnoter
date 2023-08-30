import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/activity_status.dart';
import '../../../domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';
import '../../component/duration_input_component.dart';
import '../../component/form_text_field_component.dart';
import '../../component/gap/gap_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../formatter/mood_rate_formatter.dart';
import '../../service/utils.dart';
import 'activity_status_creator_avg_pace.dart';

class ActivityStatusCreatorParamsForm extends StatelessWidget {
  const ActivityStatusCreatorParamsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivityType activityType =
        context.read<ActivityStatusCreatorBloc>().activityType;
    const Widget gap = Gap24();

    return Column(
      children: [
        const _CoveredDistance(),
        if (activityType == ActivityType.race) ...[gap, const _Duration()],
        gap,
        const _MoodRate(),
        gap,
        const ActivityStatusCreatorAvgPace(),
        gap,
        const _AvgHeartRate(),
        gap,
        const _Comment(),
      ],
    );
  }
}

class _CoveredDistance extends StatefulWidget {
  const _CoveredDistance();

  @override
  State<StatefulWidget> createState() => _CoveredDistanceState();
}

class _CoveredDistanceState extends State<_CoveredDistance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final double? coveredDistanceInKm =
        context.read<ActivityStatusCreatorBloc>().state.coveredDistanceInKm;
    if (coveredDistanceInKm != null) {
      _controller.text = context
          .convertDistanceFromDefaultUnit(coveredDistanceInKm)
          .toStringAsFixed(2);
    }
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      label:
          '${Str.of(context).activityStatusCoveredDistance} [${context.distanceUnit.toUIShortFormat()}]',
      maxLength: 8,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      isRequired: true,
      requireHigherThan0: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      controller: _controller,
      onTapOutside: (_) => unfocusInputs(),
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    final double coveredDistance = double.tryParse(_controller.text) ?? 0;
    final double convertedCoveredDistance =
        context.convertDistanceToDefaultUnit(coveredDistance);
    context.read<ActivityStatusCreatorBloc>().add(
          ActivityStatusCreatorEventCoveredDistanceInKmChanged(
            coveredDistanceInKm: convertedCoveredDistance,
          ),
        );
  }
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (ActivityStatusCreatorBloc bloc) => bloc.state.duration,
    );

    return DurationInput(
      label: Str.of(context).activityStatusDuration,
      initialDuration: duration,
      onDurationChanged: (Duration? duration) => _onChanged(context, duration),
      onSubmitted: () => _onSubmitted(context),
    );
  }

  void _onChanged(BuildContext context, Duration? duration) {
    context.read<ActivityStatusCreatorBloc>().add(
          ActivityStatusCreatorEventDurationChanged(duration: duration),
        );
  }
}

class _MoodRate extends StatelessWidget {
  const _MoodRate();

  @override
  Widget build(BuildContext context) {
    final MoodRate? moodRate = context.select(
      (ActivityStatusCreatorBloc bloc) => bloc.state.moodRate,
    );

    return DropdownButtonFormField(
      value: moodRate,
      decoration: InputDecoration(
        labelText: Str.of(context).activityStatusMoodRate,
      ),
      isExpanded: true,
      items: <DropdownMenuItem<MoodRate>>[
        ...MoodRate.values.map(
          (MoodRate moodRate) => DropdownMenuItem(
            value: moodRate,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(moodRate.toUIFormat(context)),
            ),
          ),
        ),
      ],
      selectedItemBuilder: (BuildContext context) => MoodRate.values
          .map(
            (MoodRate moodRate) => Text(
              moodRate.toUIFormat(context),
              overflow: TextOverflow.ellipsis,
            ),
          )
          .toList(),
      onChanged: (MoodRate? moodRate) => _onChanged(context, moodRate),
    );
  }

  void _onChanged(BuildContext context, MoodRate? moodRate) {
    context.read<ActivityStatusCreatorBloc>().add(
          ActivityStatusCreatorEventMoodRateChanged(
            moodRate: moodRate,
          ),
        );
  }
}

class _AvgHeartRate extends StatefulWidget {
  const _AvgHeartRate();

  @override
  State<StatefulWidget> createState() => _AvgHeartRateState();
}

class _AvgHeartRateState extends State<_AvgHeartRate> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final int? avgHeartRate =
        context.read<ActivityStatusCreatorBloc>().state.avgHeartRate;
    if (avgHeartRate != null) _controller.text = avgHeartRate.toString();
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      label: Str.of(context).activityStatusAvgHeartRate,
      maxLength: 3,
      keyboardType: TextInputType.number,
      isRequired: true,
      requireHigherThan0: true,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    final int averageHeartRate = int.tryParse(_controller.text) ?? 0;
    context.read<ActivityStatusCreatorBloc>().add(
          ActivityStatusCreatorEventAvgHeartRateChanged(
            averageHeartRate: averageHeartRate,
          ),
        );
  }
}

class _Comment extends StatefulWidget {
  const _Comment();

  @override
  State<StatefulWidget> createState() => _CommentState();
}

class _CommentState extends State<_Comment> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text =
        context.read<ActivityStatusCreatorBloc>().state.comment ?? '';
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormTextField(
      label: Str.of(context).activityStatusComment,
      maxLength: 100,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      displayCounterText: true,
      controller: _controller,
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    context.read<ActivityStatusCreatorBloc>().add(
          ActivityStatusCreatorEventCommentChanged(
            comment: _controller.text,
          ),
        );
  }
}

void _onSubmitted(BuildContext context) {
  final bloc = context.read<ActivityStatusCreatorBloc>();
  if (bloc.state.canSubmit) {
    bloc.add(const ActivityStatusCreatorEventSubmit());
  }
}
