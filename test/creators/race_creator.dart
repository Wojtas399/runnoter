import 'package:runnoter/data/model/activity.dart';
import 'package:runnoter/data/model/race.dart';

Race createRace({
  String id = '',
  String userId = '',
  String name = '',
  DateTime? date,
  String place = '',
  double distance = 0.0,
  Duration expectedDuration = const Duration(),
  ActivityStatus status = const ActivityStatusPending(),
}) =>
    Race(
      id: id,
      userId: userId,
      name: name,
      date: date ?? DateTime(2023),
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      status: status,
    );
