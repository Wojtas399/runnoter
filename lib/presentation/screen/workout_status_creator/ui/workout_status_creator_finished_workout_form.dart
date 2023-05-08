part of 'workout_status_creator_screen.dart';

class _FinishedWorkoutForm extends StatelessWidget {
  const _FinishedWorkoutForm();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return Column(
      children: [
        _CoveredDistance(),
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
      (WorkoutStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutStatusCreatorInfo.workoutStatusInitialized) {
      _controller.text = context
              .read<WorkoutStatusCreatorBloc>()
              .state
              .coveredDistanceInKm
              ?.toString() ??
          '';
    }

    return TextFieldComponent(
      label: '${Str.of(context).workoutStatusCreatorCoveredDistance} [km]',
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
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventCoveredDistanceInKmChanged(
            coveredDistanceInKm: coveredDistanceInKm,
          ),
        );
  }
}

class _MoodRate extends StatelessWidget {
  const _MoodRate();

  @override
  Widget build(BuildContext context) {
    final MoodRate? moodRate = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.moodRate,
    );

    return DropdownButtonFormField(
      value: moodRate,
      decoration: InputDecoration(
        filled: true,
        labelText: Str.of(context).workoutStatusCreatorMood,
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
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventMoodRateChanged(
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
      (WorkoutStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutStatusCreatorInfo.workoutStatusInitialized) {
      _controller.text = context
              .read<WorkoutStatusCreatorBloc>()
              .state
              .averageHeartRate
              ?.toString() ??
          '';
    }

    return TextFieldComponent(
      label: Str.of(context).workoutStatusCreatorAverageHeartRate,
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
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventAvgHeartRateChanged(
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
      (WorkoutStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == WorkoutStatusCreatorInfo.workoutStatusInitialized) {
      _controller.text =
          context.read<WorkoutStatusCreatorBloc>().state.comment ?? '';
    }

    return TextFieldComponent(
      label: Str.of(context).workoutStatusCreatorComment,
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
    context.read<WorkoutStatusCreatorBloc>().add(
          WorkoutStatusCreatorEventCommentChanged(
            comment: comment,
          ),
        );
  }
}
