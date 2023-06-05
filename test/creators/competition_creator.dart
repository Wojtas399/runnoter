import 'package:runnoter/domain/entity/competition.dart';
import 'package:runnoter/domain/entity/run_status.dart';

Competition createCompetition({
  String id = '',
  String userId = '',
  String name = '',
  DateTime? date,
  String place = '',
  double distance = 0.0,
  Time expectedTime = const Time(hour: 0, minute: 0, second: 0),
  RunStatus status = const RunStatusPending(),
}) =>
    Competition(
      id: id,
      userId: userId,
      name: name,
      date: date ?? DateTime(2023),
      place: place,
      distance: distance,
      expectedTime: expectedTime,
      status: status,
    );
