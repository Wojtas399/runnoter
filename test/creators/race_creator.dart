import 'package:runnoter/domain/additional_model/run_status.dart';
import 'package:runnoter/domain/entity/race.dart';

Race createRace({
  String id = '',
  String userId = '',
  String name = '',
  DateTime? date,
  String place = '',
  double distance = 0.0,
  Duration expectedDuration = const Duration(),
  RunStatus status = const RunStatusPending(),
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
