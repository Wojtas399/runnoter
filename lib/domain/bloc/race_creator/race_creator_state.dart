part of 'race_creator_bloc.dart';

class RaceCreatorState extends BlocState<RaceCreatorState> {
  final Race? race;
  final String? name;
  final DateTime? date;
  final String? place;
  final double? distance;
  final Duration? expectedDuration;

  const RaceCreatorState({
    required super.status,
    this.race,
    this.name,
    this.date,
    this.place,
    this.distance,
    this.expectedDuration,
  });

  @override
  List<Object?> get props => [
        status,
        race,
        name,
        date,
        place,
        distance,
        expectedDuration,
      ];

  bool get canSubmit => _areDataValid && _areDataDifferentThanOriginal;

  bool get _areDataValid =>
      name != null &&
      name!.isNotEmpty &&
      date != null &&
      place != null &&
      place!.isNotEmpty &&
      distance != null &&
      distance! > 0;

  bool get _areDataDifferentThanOriginal =>
      name != race?.name ||
      (date != null &&
          race?.date != null &&
          !date!.isAtSameMomentAs(race!.date)) ||
      place != race?.place ||
      distance != race?.distance ||
      expectedDuration != race?.expectedDuration;

  @override
  RaceCreatorState copyWith({
    BlocStatus? status,
    Race? race,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      RaceCreatorState(
        status: status ?? const BlocStatusComplete(),
        race: race ?? this.race,
        name: name ?? this.name,
        date: date ?? this.date,
        place: place ?? this.place,
        distance: distance ?? this.distance,
        expectedDuration: expectedDuration ?? this.expectedDuration,
      );
}
