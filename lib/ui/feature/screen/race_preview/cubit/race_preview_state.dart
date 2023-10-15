part of 'race_preview_cubit.dart';

class RacePreviewState extends Equatable {
  final String? name;
  final DateTime? date;
  final String? place;
  final double? distance;
  final Duration? expectedDuration;
  final ActivityStatus? raceStatus;

  const RacePreviewState({
    this.name,
    this.date,
    this.place,
    this.distance,
    this.expectedDuration,
    this.raceStatus,
  });

  @override
  List<Object?> get props => [
        name,
        date,
        place,
        distance,
        expectedDuration,
        raceStatus,
      ];

  bool get isRaceLoaded =>
      name != null &&
      date != null &&
      place != null &&
      distance != null &&
      raceStatus != null;

  RacePreviewState copyWith({
    final String? name,
    final DateTime? date,
    final String? place,
    final double? distance,
    final Duration? expectedDuration,
    final ActivityStatus? raceStatus,
  }) =>
      RacePreviewState(
        name: name ?? this.name,
        date: date ?? this.date,
        place: place ?? this.place,
        distance: distance ?? this.distance,
        expectedDuration: expectedDuration ?? this.expectedDuration,
        raceStatus: raceStatus ?? this.raceStatus,
      );
}
