part of 'race_preview_bloc.dart';

class RacePreviewState extends BlocState<RacePreviewState> {
  final String? name;
  final DateTime? date;
  final String? place;
  final double? distance;
  final Duration? expectedDuration;
  final ActivityStatus? raceStatus;

  const RacePreviewState({
    required super.status,
    this.name,
    this.date,
    this.place,
    this.distance,
    this.expectedDuration,
    this.raceStatus,
  });

  @override
  List<Object?> get props => [
        status,
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

  @override
  RacePreviewState copyWith({
    final BlocStatus? status,
    final String? name,
    final DateTime? date,
    final String? place,
    final double? distance,
    final Duration? expectedDuration,
    final ActivityStatus? raceStatus,
  }) =>
      RacePreviewState(
        status: status ?? const BlocStatusComplete(),
        name: name ?? this.name,
        date: date ?? this.date,
        place: place ?? this.place,
        distance: distance ?? this.distance,
        expectedDuration: expectedDuration ?? this.expectedDuration,
        raceStatus: raceStatus ?? this.raceStatus,
      );
}
