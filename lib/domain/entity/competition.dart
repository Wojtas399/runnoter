import 'package:equatable/equatable.dart';

import 'entity.dart';
import 'run_status.dart';

class Competition extends Entity {
  final String userId;
  final String name;
  final DateTime date;
  final String place;
  final double distance;
  final Time expectedTime;
  final RunStatus status;

  const Competition({
    required super.id,
    required this.userId,
    required this.name,
    required this.date,
    required this.place,
    required this.distance,
    required this.expectedTime,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        date,
        place,
        distance,
        expectedTime,
        status,
      ];
}

class Time extends Equatable {
  final int hour;
  final int minute;
  final int second;

  const Time({
    required this.hour,
    required this.minute,
    required this.second,
  })  : assert(hour >= 0),
        assert(minute >= 0),
        assert(second >= 0);

  @override
  List<Object?> get props => [
        hour,
        minute,
        second,
      ];
}
