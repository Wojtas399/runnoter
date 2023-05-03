part of 'workout_status_creator_screen.dart';

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
