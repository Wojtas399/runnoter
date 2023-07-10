part of 'run_status_creator_screen.dart';

class _ParamsForm extends StatelessWidget {
  const _ParamsForm();

  @override
  Widget build(BuildContext context) {
    final EntityType entityType =
        context.read<RunStatusCreatorBloc>().state.entityType;
    const Widget gap = SizedBox(height: 24);

    return Column(
      children: [
        const _CoveredDistance(),
        if (entityType == EntityType.race)
          const Column(
            children: [
              gap,
              _Duration(),
            ],
          ),
        gap,
        const _MoodRate(),
        gap,
        const _AvgPace(),
        gap,
        const _AvgHeartRate(),
        gap,
        const _Comment(),
      ],
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
                moodRate.toUIFormat(context),
              ),
            ),
          ),
        ),
      ],
      selectedItemBuilder: (BuildContext context) {
        return MoodRate.values.map((MoodRate moodRate) {
          return Text(
            moodRate.toUIFormat(context),
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
