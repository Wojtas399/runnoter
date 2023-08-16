import 'package:firebase/firebase.dart';

RaceDto createRaceDto({
  String id = '',
  String userId = '',
  String name = '',
  DateTime? date,
  String place = '',
  double distance = 0.0,
  Duration expectedDuration = const Duration(),
  ActivityStatusDto status = const ActivityStatusPendingDto(),
}) =>
    RaceDto(
      id: id,
      userId: userId,
      name: name,
      date: date ?? DateTime(2023),
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      statusDto: status,
    );
