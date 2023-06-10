Duration mapDurationFromString(String str) {
  final List<String> durationParts = str.split(':');
  final int hours = int.parse(durationParts.first);
  final int minutes = int.parse(durationParts[1]);
  final int seconds = int.parse(durationParts[2]);
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

String mapDurationToString(Duration duration) {
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);
  return '$hours:$minutes:$seconds';
}
