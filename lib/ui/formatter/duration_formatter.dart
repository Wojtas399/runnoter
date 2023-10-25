extension DurationFormatter on Duration {
  String toUIFormat() {
    final int minutes = inMinutes % 60;
    final int seconds = inSeconds % 60;
    final List<String> durationParts = [];
    if (inHours > 0) {
      durationParts.add('${inHours}h');
    }
    if (minutes > 0) {
      durationParts.add('${minutes}m');
    }
    if (seconds > 0) {
      durationParts.add('${seconds}s');
    }
    if (durationParts.isNotEmpty) {
      return durationParts.join(' ');
    }
    return '0h 0m 0s';
  }
}
