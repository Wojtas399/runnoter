part of 'run_status_creator_screen.dart';

class _FinishedWorkoutForm extends StatelessWidget {
  const _FinishedWorkoutForm();

  @override
  Widget build(BuildContext context) {
    final EntityType entityType =
        context.read<RunStatusCreatorBloc>().state.entityType;
    const Widget gap = SizedBox(height: 24);

    return Column(
      children: [
        _CoveredDistance(),
        if (entityType == EntityType.competition)
          const Column(
            children: [
              gap,
              _Duration(),
            ],
          ),
        gap,
        const _MoodRate(),
        gap,
        const _AveragePace(),
        gap,
        _AverageHeartRate(),
        gap,
        _Comment(),
      ],
    );
  }
}

class _CoveredDistance extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RunStatusCreatorBlocInfo.runStatusInitialized) {
      _controller.text = context
              .read<RunStatusCreatorBloc>()
              .state
              .coveredDistanceInKm
              ?.toString() ??
          '';
    }

    return TextFieldComponent(
      label: '${Str.of(context).runStatusCreatorCoveredDistance} [km]',
      maxLength: 8,
      keyboardType: TextInputType.number,
      isRequired: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      controller: _controller,
      onChanged: (String? coveredDistanceInKmStr) {
        _onChanged(context, coveredDistanceInKmStr);
      },
    );
  }

  void _onChanged(BuildContext context, String? coveredDistanceInKmStr) {
    if (coveredDistanceInKmStr == null) {
      return;
    }
    final double? coveredDistanceInKm = double.tryParse(coveredDistanceInKmStr);
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventCoveredDistanceInKmChanged(
            coveredDistanceInKm: coveredDistanceInKm,
          ),
        );
  }
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.duration,
    );

    return DurationInput(
      label: Str.of(context).runStatusCreatorDuration,
      initialDuration: duration,
      onDurationChanged: (Duration? duration) {
        _onChanged(context, duration);
      },
    );
  }

  void _onChanged(BuildContext context, Duration? duration) {
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventDurationChanged(duration: duration),
        );
  }
}

class _MoodRate extends StatelessWidget {
  const _MoodRate();

  @override
  Widget build(BuildContext context) {
    final MoodRate? moodRate = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.moodRate,
    );

    return DropdownButtonFormField(
      value: moodRate,
      decoration: InputDecoration(
        filled: true,
        labelText: Str.of(context).runStatusCreatorMood,
      ),
      isExpanded: true,
      items: <DropdownMenuItem<MoodRate>>[
        ...MoodRate.values.map(
          (MoodRate moodRate) => DropdownMenuItem(
            value: moodRate,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                moodRate.toUIFormat(),
              ),
            ),
          ),
        ),
      ],
      selectedItemBuilder: (BuildContext context) {
        return MoodRate.values.map((MoodRate moodRate) {
          return Text(
            moodRate.toUIFormat(),
            overflow: TextOverflow.ellipsis,
          );
        }).toList();
      },
      onChanged: (MoodRate? moodRate) {
        _onChanged(context, moodRate);
      },
    );
  }

  void _onChanged(BuildContext context, MoodRate? moodRate) {
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventMoodRateChanged(
            moodRate: moodRate,
          ),
        );
  }
}

class _AverageHeartRate extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RunStatusCreatorBlocInfo.runStatusInitialized) {
      _controller.text = context
              .read<RunStatusCreatorBloc>()
              .state
              .averageHeartRate
              ?.toString() ??
          '';
    }

    return TextFieldComponent(
      label: Str.of(context).runStatusCreatorAverageHeartRate,
      maxLength: 3,
      keyboardType: TextInputType.number,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
      onChanged: (String? averageHeartRateStr) {
        _onChanged(context, averageHeartRateStr);
      },
    );
  }

  void _onChanged(BuildContext context, String? averageHeartRateStr) {
    if (averageHeartRateStr == null) {
      return;
    }
    final int? averageHeartRate = int.tryParse(averageHeartRateStr);
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventAvgHeartRateChanged(
            averageHeartRate: averageHeartRate,
          ),
        );
  }
}

class _Comment extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RunStatusCreatorBlocInfo.runStatusInitialized) {
      _controller.text =
          context.read<RunStatusCreatorBloc>().state.comment ?? '';
    }

    return TextFieldComponent(
      label: Str.of(context).runStatusCreatorComment,
      maxLength: 100,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      displayCounterText: true,
      controller: _controller,
      onChanged: (String? comment) {
        _onChanged(context, comment);
      },
    );
  }

  void _onChanged(BuildContext context, String? comment) {
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventCommentChanged(
            comment: comment,
          ),
        );
  }
}
