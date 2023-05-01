part of 'workout_status_creator_screen.dart';

class _AveragePace extends StatelessWidget {
  const _AveragePace();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!
              .workout_status_creator_average_pace_label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _AveragePaceField(
                  label: AppLocalizations.of(context)!
                      .workout_status_creator_minutes_label,
                ),
              ),
            ),
            Text(
              ':',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _AveragePaceField(
                  label: AppLocalizations.of(context)!
                      .workout_status_creator_seconds_label,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AveragePaceField extends StatelessWidget {
  final String label;

  const _AveragePaceField({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: label,
      isLabelCentered: true,
      textAlign: TextAlign.center,
      maxLength: 2,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
