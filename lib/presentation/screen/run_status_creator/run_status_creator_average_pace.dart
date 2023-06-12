part of 'run_status_creator_screen.dart';

class _AveragePace extends StatelessWidget {
  const _AveragePace();

  @override
  Widget build(BuildContext context) {
    if (context.paceUnit == PaceUnit.kilometersPerHour ||
        context.paceUnit == PaceUnit.milesPerHour) {
      return _AveragePaceDistance();
    } else if (context.paceUnit == PaceUnit.minutesPerKilometer ||
        context.paceUnit == PaceUnit.minutesPerMile) {
      return _AveragePaceTime();
    }
    return const SizedBox();
  }
}
