import 'package:equatable/equatable.dart';

class TimeDto extends Equatable {
  final int hour;
  final int minute;
  final int second;

  const TimeDto({
    required this.hour,
    required this.minute,
    required this.second,
  })  : assert(hour >= 0),
        assert(minute >= 0),
        assert(second >= 0);

  factory TimeDto.fromString(String timeStr) {
    final List<String> splittedTime = timeStr.split(':');
    final int hour = int.parse(splittedTime.first);
    final int minute = int.parse(splittedTime[1]);
    final int second = int.parse(splittedTime[2]);
    return TimeDto(
      hour: hour,
      minute: minute,
      second: second,
    );
  }

  @override
  List<Object?> get props => [
        hour,
        minute,
        second,
      ];

  @override
  String toString() => '$hour:$minute:$second';
}
