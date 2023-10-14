import 'package:runnoter/data/additional_model/activity_status.dart';
import 'package:runnoter/data/entity/race.dart';

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
