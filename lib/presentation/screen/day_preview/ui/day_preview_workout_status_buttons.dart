part of 'day_preview_screen.dart';

class _WorkoutStatusButtons extends StatelessWidget {
  const _WorkoutStatusButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(
          label: AppLocalizations.of(context)!
              .day_preview_screen_finish_workout_button_label,
          onPressed: () {},
        ),
      ],
    );
  }
}
