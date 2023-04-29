import '../../domain/model/workout_status.dart';
import '../service/utils.dart';

extension PaceFormatter on Pace {
  String toUIFormat() {
    final String minutesStr = twoDigits(minutes);
    final String secondsStr = twoDigits(seconds);
    return '$minutesStr:$secondsStr min/km';
  }
}
