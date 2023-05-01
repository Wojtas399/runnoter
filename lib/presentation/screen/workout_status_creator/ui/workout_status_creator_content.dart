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
                  _CoveredDistance(),
                  SizedBox(height: 24),
                  _MoodRate(),
                  SizedBox(height: 24),
                  _AveragePace(),
                  SizedBox(height: 24),
                  _AverageHeartRate(),
                  SizedBox(height: 24),
                  _Comment(),
                ],
              ),
            ),
          ),
        ),
      ),
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
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
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
        //TODO
      },
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
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
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
    );
  }
}
