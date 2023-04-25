part of 'day_preview_screen.dart';

class _WorkoutStatusButtons extends StatelessWidget {
  const _WorkoutStatusButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomFilledButton(
          size: ButtonSize.medium,
          label: 'Nieukończony',
          color: Colors.red,
          onPressed: () {},
        ),
        const SizedBox(width: 32),
        CustomFilledButton(
          size: ButtonSize.medium,
          label: 'Ukończony',
          color: Colors.green,
          onPressed: () {},
        ),
      ],
    );
  }
}
