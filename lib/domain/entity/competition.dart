import 'package:equatable/equatable.dart';

import 'entity.dart';
import 'run_status.dart';

class Competition extends Entity {
  final String userId;
  final String name;
  final DateTime date;
  final String city;
  final double distance;
  final Time expectedTime;
  final RunStatus status;

  const Competition({
    required super.id,
    required this.userId,
    required this.name,
    required this.date,
    required this.city,
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
        city,
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
  });

  @override
  List<Object?> get props => [
        hour,
        minute,
        second,
      ];
}
