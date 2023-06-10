import 'package:firebase/firebase.dart';

CompetitionDto createCompetitionDto({
  String id = '',
  String userId = '',
  String name = '',
  DateTime? date,
  String place = '',
  double distance = 0.0,
  Duration expectedDuration = const Duration(),
  RunStatusDto status = const RunStatusPendingDto(),
}) =>
    CompetitionDto(
      id: id,
      userId: userId,
      name: name,
      date: date ?? DateTime(2023),
      place: place,
      distance: distance,
      expectedDuration: expectedDuration,
      statusDto: status,
    );
