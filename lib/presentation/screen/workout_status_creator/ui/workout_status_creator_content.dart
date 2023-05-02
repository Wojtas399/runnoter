part of 'workout_status_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.workout_status_creator_screen_title,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ScrollableContent(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  _StatusType(),
                  SizedBox(height: 24),
                  _Form(),
                  SizedBox(height: 24),
                  _SubmitButton(),
                ],
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
    final WorkoutStatusType? workoutStatusType = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.workoutStatusType,
    );

    if (workoutStatusType == WorkoutStatusType.completed ||
        workoutStatusType == WorkoutStatusType.uncompleted) {
      return const _FinishedWorkoutForm();
    }
    return const SizedBox();
  }
}

class _FinishedWorkoutForm extends StatelessWidget {
  const _FinishedWorkoutForm();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return Column(
      children: const [
        _CoveredDistance(),
        gap,
        _MoodRate(),
        gap,
        _AveragePace(),
        gap,
        _AverageHeartRate(),
        gap,
        _Comment(),
      ],
    );
  }
}

class _CoveredDistance extends StatelessWidget {
  const _CoveredDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label:
          '${AppLocalizations.of(context)!.workout_status_creator_covered_distance_label} [km]',
      maxLength: 8,
      keyboardType: TextInputType.number,
      isRequired: true,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
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
    return DropdownButtonFormField(
      decoration: InputDecoration(
        filled: true,
        labelText:
            AppLocalizations.of(context)!.workout_status_creator_mood_label,
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
  const _AverageHeartRate();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: AppLocalizations.of(context)!
          .workout_status_creator_average_heart_rate,
      maxLength: 3,
      keyboardType: TextInputType.number,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
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
  const _Comment();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: AppLocalizations.of(context)!.workout_status_creator_comment_label,
      maxLength: 100,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      displayCounterText: true,
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (WorkoutStatusCreatorBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: AppLocalizations.of(context)!.save,
      isDisabled: isDisabled,
      onPressed: () {
        //TODO
      },
    );
  }
}
