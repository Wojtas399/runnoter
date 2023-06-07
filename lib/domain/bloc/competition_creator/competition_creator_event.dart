part of 'competition_creator_bloc.dart';

abstract class CompetitionCreatorEvent {
  const CompetitionCreatorEvent();
}

class CompetitionCreatorEventNameChanged extends CompetitionCreatorEvent {
  final String? name;

  const CompetitionCreatorEventNameChanged({
    required this.name,
  });
}

class CompetitionCreatorEventDateChanged extends CompetitionCreatorEvent {
  final DateTime? date;

  const CompetitionCreatorEventDateChanged({
    required this.date,
  });
}

class CompetitionCreatorEventPlaceChanged extends CompetitionCreatorEvent {
  final String? place;

  const CompetitionCreatorEventPlaceChanged({
    required this.place,
  });
}

class CompetitionCreatorEventDistanceChanged extends CompetitionCreatorEvent {
  final double? distance;

  const CompetitionCreatorEventDistanceChanged({
    required this.distance,
  });
}

class CompetitionCreatorEventExpectedDurationChanged
    extends CompetitionCreatorEvent {
  final Duration? expectedDuration;

  const CompetitionCreatorEventExpectedDurationChanged({
    required this.expectedDuration,
  });
}

class CompetitionCreatorEventSubmit extends CompetitionCreatorEvent {
  const CompetitionCreatorEventSubmit();
}
